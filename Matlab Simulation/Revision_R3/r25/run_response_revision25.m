function run_response_revision25(output)
% Reply-only studies with the finalized manuscript's nominal parameters.
if nargin<1,output=fullfile(fileparts(mfilename('fullpath')),'results');end
if ~exist(output,'dir'),mkdir(output);end
addpath(fileparts(fileparts(mfilename('fullpath'))));
diary(fullfile(output,'run.log'));cleaner=onCleanup(@()diary('off')); %#ok<NASGU>
fprintf('MATLAB %s\n',version);tic;
w=struct('seed',11,'samples',100000,'channels',12,'spatial','uniform',...
    'room_xy',[10,10],'ap_xy',[5,5],'height_difference_m',1,...
    'cluster_center',[2,2],'cluster_sigma_m',.6,'fixed_xy',[2.5,5],...
    'shadow_near_db',3,'shadow_far_db',5,'breakpoint_m',5,'shadow_correlation',0,...
    'rician_k',1,'carrier_hz',5e9,'bandwidth_hz',40e6,'power_per_channel_w',1,...
    'temperature_k',288.15,'noise_figure_db',0,'outage_threshold_bps',8e9,...
    'path_loss_model','piecewise');
scenarios={'nominal','clustered','offset_ap','correlation_03','correlation_07','correlation_09',...
    'channels_6','channels_24','power_01','power_2','noise_7','shadow_0','shadow_6_8','rician_0','rician_5','height_2'};
wifi=struct([]);
for seed=11:15
    for j=1:numel(scenarios)
        q=w;q.seed=seed;name=scenarios{j};
        switch name
            case 'clustered',q.spatial='clustered';
            case 'offset_ap',q.ap_xy=[1,1];
            case 'correlation_03',q.shadow_correlation=.3;
            case 'correlation_07',q.shadow_correlation=.7;
            case 'correlation_09',q.shadow_correlation=.9;
            case 'channels_6',q.channels=6;
            case 'channels_24',q.channels=24;
            case 'power_01',q.power_per_channel_w=.1;
            case 'power_2',q.power_per_channel_w=2;
            case 'noise_7',q.noise_figure_db=7;
            case 'shadow_0',q.shadow_near_db=0;q.shadow_far_db=0;
            case 'shadow_6_8',q.shadow_near_db=6;q.shadow_far_db=8;
            case 'rician_0',q.rician_k=0;
            case 'rician_5',q.rician_k=5;
            case 'height_2',q.height_difference_m=2;
        end
        z=throughput_estimate(q);
        value=struct('scenario',name,'seed',seed,'mean_gbps',z.mean_bps/1e9,...
            'p05_gbps',z.p05_bps/1e9,'p95_gbps',z.p95_bps/1e9,...
            'standard_error_gbps',z.standard_error_bps/1e9,'mean_distance_m',z.mean_distance_m); %#ok<AGROW>
        if isempty(wifi),wifi=value;else,wifi(end+1)=value;end %#ok<AGROW>
    end
end
writetable(struct2table(wifi),fullfile(output,'wifi_sensitivity.csv'));
nominal=wifi(strcmp({wifi.scenario},'nominal'));
assert(abs(mean([nominal.mean_gbps])-10.8)<.1);
writejson(fullfile(output,'wifi_configuration.json'),w);
fprintf('WiFi nominal %.6f Gbit/s; %d runs completed.\n',mean([nominal.mean_gbps]),numel(wifi));

[x,y]=meshgrid(1:2:9,1:2:9);
c=struct('mode','ledger','horizon',1800,'dt',.1,'capacity',3,'confirmations',0,...
    'ld',[reshape(x',[],1),reshape(y',[],1),3*ones(25,1)],'batch_size',20,'transactions_per_block',4,...
    'control_transport_s',.02,'assignment_read_s',.02,'traffic_probability',.01,...
    'lambertian_order',10,'pd_area_m2',1e-4,'fov_deg',30,'optical_bandwidth_hz',100e6,...
    'optical_power_w',13,'responsivity_a_w',1,'noise_psd_a2_hz',1e-21);
writejson(fullfile(output,'hybrid_configuration.json'),c);
rows=struct([]);modes={'hybrid_no_ledger','hybrid_centralized','ledger_inclusion','ledger_four_later'};
for seed=1:5
    tape=make_tape(seed,c.horizon,c.dt,50);
    save(fullfile(output,sprintf('tape_seed%d.mat',seed)),'tape');
    for probability=[.001,.003,.01,.03,.1,.3]
        previous=[];
        for k=1:4
            q=c;q.traffic_probability=probability;q.mode=modes{k};
            if k>=3,q.mode='ledger';end
            if k==4,q.confirmations=4;end
            r=simulate_paper_matched(tape,q);
            if k==2,assert(isequaln(previous,r.records));end
            if k==1,previous=r.records;end
            value=metricrow(r,seed,probability,modes{k},'matched');
            if isempty(rows),rows=value;else,rows(end+1)=value;end %#ok<AGROW>
            if seed==1 && probability==.01
                writematrix(r.records,fullfile(output,['requests_' modes{k} '.csv']));
            end
        end
        fprintf('Matched seed %d, per-round probability %.3g complete.\n',seed,probability);
    end
    for confirmation=[0,1,2,4,8]
        q=c;q.confirmations=confirmation;q.traffic_probability=.01;
        r=simulate_paper_matched(tape,q);
        rows(end+1)=metricrow(r,seed,.01,'ledger','confirmations'); %#ok<AGROW>
    end
    for capacity=[1,3,6]
        q=c;q.capacity=capacity;q.traffic_probability=.01;
        r=simulate_paper_matched(tape,q);
        rows(end+1)=metricrow(r,seed,.01,'ledger','capacity'); %#ok<AGROW>
    end
    writetable(struct2table(rows),fullfile(output,'hybrid_runs.csv'));
end
writetable(struct2table(rows),fullfile(output,'hybrid_runs.csv'));
writejson(fullfile(output,'validation.json'),struct('passed',true,'wifi_runs',numel(wifi),...
    'hybrid_runs',numel(rows),'native_runtime',version,'elapsed_s',toc,...
    'configuration_source','Final Supplementary A-C, with the explicit additional block-capacity model',...
    'checks',{{'nominal room-area rate rounds to 10.8 Gbit/s',...
    'no-ledger and centralized traces identical under the common illustrative allocator',...
    'request conservation, acceptance before service, FIFO occupancy consistency',...
    'user position fixed throughout each outstanding request; update after completion or rejection'}}));
fprintf('PASS: %d WiFi and %d hybrid runs, %.1f s.\n',numel(wifi),numel(rows),toc);
end
function tape=make_tape(seed,horizon,dt,users)
rng(seed,'twister');n=round(horizon/dt)+1;
tape=struct('attempt',rand(n,users),'x',rand(n,users),'y',rand(n,users),'payload',rand(n,users));
rng(seed+10000,'twister');tape.block_times=cumsum(-12*log(max(rand(ceil(horizon/12)*4+200,1),realmin)));
assert(tape.block_times(end)>horizon+200);
end
function s=metricrow(r,seed,p,mode,experiment)
s=struct('seed',seed,'traffic_probability',p,'mode',mode,'experiment',experiment,...
    'capacity',r.cfg.capacity,'confirmations',r.cfg.confirmations,...
    'batch_size',r.cfg.batch_size,'transactions_per_block',r.cfg.transactions_per_block);
names=fieldnames(r.metrics);for j=1:numel(names),s.(names{j})=r.metrics.(names{j});end
end
function writejson(path,value)
f=fopen(path,'w');assert(f>=0);cleanup=onCleanup(@()fclose(f)); %#ok<NASGU>
fprintf(f,'%s\n',jsonencode(value,'PrettyPrint',true));
end
