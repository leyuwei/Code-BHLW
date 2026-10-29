function run_response32()
% Reuse R27 unchanged. Only the four coordination-failure fractions change.
project=fileparts(fileparts(mfilename('fullpath')));
output=fullfile(project,'results','revision32','matlab');
previous=fullfile(project,'results','revision25','matlab');
addpath(project);addpath(fullfile(project,'r27'));
assert(strcmp(which('simulate_paper_matched27'),fullfile(project,'r27','simulate_paper_matched27.m')));
if ~exist(output,'dir'),mkdir(output);end
trace_dir=fullfile(output,'traces');if ~exist(trace_dir,'dir'),mkdir(trace_dir);end
diary(fullfile(output,'run.log'));finish=onCleanup(@()diary('off')); %#ok<NASGU>
start=tic;fprintf('MATLAB %s\n',version);
c=jsondecode(fileread(fullfile(previous,'hybrid_configuration.json')));
c.outage_period_s=120;c.outage_duty=0;c.miners=273;c.confirmations=0;
assert(c.optical_power_w==13 && c.capacity==3 && c.dt==.1 && c.horizon==1800);
assert(c.batch_size==20 && c.transactions_per_block==4 && c.traffic_probability==.01);
rows=struct([]);
for seed=1:5
    saved=load(fullfile(previous,sprintf('tape_seed%d.mat',seed)));original=saved.tape;
    assert(size(original.attempt,2)==50);
    for duty=[0,.1,.7,.8]
        probabilities=.01;
        if duty==.8
            probabilities=[.0005,.001,.002,.003,.005,.007,.01,.015,.02,.03,.05,.1,.2,.3];
        end
        for p=probabilities
            direct=[];
            for names={'hybrid_no_ledger','hybrid_centralized','ledger'}
                q=c;q.outage_duty=duty;q.traffic_probability=p;q.mode=names{1};tape=original;
                if strcmp(q.mode,'ledger')
                    tape.block_times=warp_blocks27(original.block_times,q.outage_period_s,duty,q.miners);
                end
                r=simulate_paper_matched27(tape,q);
                if strcmp(q.mode,'hybrid_no_ledger'),direct=r.records;
                elseif strcmp(q.mode,'hybrid_centralized'),assert(isequaln(direct,r.records));end
                value=struct('seed',seed,'traffic_probability',p,'request_frequency_s',p/q.dt,...
                    'mode',q.mode,'outage_duty',duty,'period_s',q.outage_period_s,'miners',q.miners);
                for key=fieldnames(r.metrics)',value.(key{1})=r.metrics.(key{1});end
                if isempty(rows),rows=value;else,rows(end+1)=value;end %#ok<AGROW>
                filename=sprintf('p%g_d%g_%s_seed%d.mat',p,duty,q.mode,seed);
                save(fullfile(trace_dir,filename),'r','value','-v7');
            end
        end
    end
    writetable(struct2table(rows),fullfile(output,'runs.csv'));
    fprintf('Seed %d complete: %d runs, %.1f s\n',seed,numel(rows),toc(start));
end
assert(numel(rows)==255);
validation=struct('passed',true,'runs',numel(rows),'elapsed_s',toc(start),'runtime',version,...
    'users',50,'table_probability',.01,'outage_duties',[0,.1,.7,.8],...
    'figure_outage_duty',.8,'original_tapes_reused',true,...
    'model_functions_unchanged',true,'two_baseline_records_equal',true);
f=fopen(fullfile(output,'configuration.json'),'w');fprintf(f,'%s',jsonencode(c,'PrettyPrint',true));fclose(f);
f=fopen(fullfile(output,'native_validation.json'),'w');fprintf(f,'%s',jsonencode(validation,'PrettyPrint',true));fclose(f);
fprintf('PASS %d runs, %.1f s\n',numel(rows),toc(start));
end
