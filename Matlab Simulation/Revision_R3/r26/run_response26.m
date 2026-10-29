function run_response26(output,previous)
if ~exist(output,'dir'),mkdir(output);end
addpath(fileparts(fileparts(mfilename('fullpath'))));
diary(fullfile(output,'run.log'));cleanup=onCleanup(@()diary('off'));tic; %#ok<NASGU>
fprintf('R26 %s\n',version);
w=jsondecode(fileread(fullfile(previous,'wifi_configuration.json')));rows=[];
for seed=11:15
 for spatial={'uniform','clustered'}
  for rho=0:.1:1
   q=w;q.seed=seed;q.spatial=spatial{1};q.shadow_correlation=rho;
   z=throughput_estimate(q);
   value=struct('seed',seed,'spatial',q.spatial,'correlation',rho,'mean_gbps',z.mean_bps/1e9,'p05_gbps',z.p05_bps/1e9,'p95_gbps',z.p95_bps/1e9);
   if isempty(rows),rows=value;else,rows(end+1)=value;end %#ok<AGROW>
  end
 end
end
writetable(struct2table(rows),fullfile(output,'wifi_correlation.csv'));
c=jsondecode(fileread(fullfile(previous,'hybrid_configuration.json')));rows=[];
probabilities=[.0005,.001,.002,.003,.005,.007,.01,.015,.02,.03,.05,.1,.2,.3];
for seed=1:5
 saved=load(fullfile(previous,sprintf('tape_seed%d.mat',seed)));tape=saved.tape;
 for p=probabilities
  direct=[];
  for k=1:6
   q=c;q.traffic_probability=p;q.confirmations=0;
   if k==1,q.mode='hybrid_no_ledger';name=q.mode;
   elseif k==2,q.mode='hybrid_centralized';name=q.mode;
   else,q.mode='ledger';values=[0,1,2,4];q.confirmations=values(k-2);name=sprintf('ledger_c%d',q.confirmations);end
   r=simulate_paper_matched26(tape,q);
   if k==1,direct=r.records;elseif k==2,assert(isequaln(direct,r.records));end
   rows=append(rows,metric(r,seed,p,name,'matched'));
   if seed==1 && p==.01,writematrix(r.records,fullfile(output,['requests_' name '.csv']));end
  end
 end
 for p=[.003,.01,.1]
  for conf=0:8
   q=c;q.mode='ledger';q.traffic_probability=p;q.confirmations=conf;
   r=simulate_paper_matched26(tape,q);rows=append(rows,metric(r,seed,p,'ledger','confirmations'));
  end
 end
 for cap=[1,3,6]
  q=c;q.mode='ledger';q.capacity=cap;q.confirmations=0;q.traffic_probability=.01;
  r=simulate_paper_matched26(tape,q);rows=append(rows,metric(r,seed,.01,'ledger','capacity'));
 end
 writetable(struct2table(rows),fullfile(output,'hybrid_runs.csv'));
 fprintf('Seed %d complete, %d hybrid runs.\n',seed,numel(rows));
end
% Deterministic single-request timing check against the direct optical formula.
q=c;q.ld=[1,1,3];q.mode='ledger';q.confirmations=2;q.horizon=20;
t=struct('attempt',ones(201,1),'x',.1*ones(201,1),'y',.1*ones(201,1),'payload',zeros(201,1),'block_times',[2;5;9;14;25;30;40]);t.attempt(1)=0;
r=simulate_paper_matched26(t,q);gain=(q.lambertian_order+1)*q.pd_area_m2/(2*pi*4);
rate=q.optical_bandwidth_hz*log2(1+(gain*q.optical_power_w*q.responsivity_a_w)^2/(q.optical_bandwidth_hz*q.noise_psd_a2_hz));
assert(size(r.records,1)==1 && r.records(1,4)==2 && abs(r.records(1,5)-9.1)<1e-9 && r.records(1,16)==7);
assert(abs(r.records(1,8)-(9.1+1e9/rate))<1e-8);
% A solitary request whose AP transport crosses a block must wait for the next.
t.attempt(:)=1;t.attempt(21)=0;q.control_transport_s=.12;
r=simulate_paper_matched26(t,q);assert(size(r.records,1)==1 && r.records(1,4)==5);
% Zero arrivals and deterministic half-step check.
t.attempt(:)=1;empty=simulate_paper_matched26(t,q);assert(empty.metrics.offered==0);
% Save independent block-wait samples. Their Gamma law is checked separately.
rng(2601);wait=cumsum(-12*log(max(rand(200000,8),realmin)),2);
sorted=sort(wait,1);quantiles=sorted(ceil(200000*[.05,.5,.95]),:);writematrix(quantiles,fullfile(output,'confirmation_quantiles.csv'));
writematrix(wait(1:20000,:),fullfile(output,'confirmation_samples.csv'));
summary=struct('passed',true,'wifi_runs',110,'hybrid_runs',numel(rows),'block_wait_samples',200000,'elapsed_s',toc,...
 'checks',{{'direct and centralized records identical','single-user inclusion/confirmation/start/completion match independent calculation','zero-arrival case','per-request stage sum and queue conservation'}});
f=fopen(fullfile(output,'validation.json'),'w');fprintf(f,'%s',jsonencode(summary,'PrettyPrint',true));fclose(f);
fprintf('PASS %d hybrid runs, %.1f s\n',numel(rows),toc);
end
function rows=append(rows,value)
if isempty(rows),rows=value;else,rows(end+1)=value;end
end
function value=metric(r,seed,p,mode,experiment)
value=struct('seed',seed,'traffic_probability',p,'mode',mode,'experiment',experiment,'capacity',r.cfg.capacity,'confirmations',r.cfg.confirmations);
for name=fieldnames(r.metrics)',value.(name{1})=r.metrics.(name{1});end
end
