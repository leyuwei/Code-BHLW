function r=simulate_paper_matched(tape,c)
% Same paper channels, capacity-three, nearest-LD example and closed-loop users.
% Only the controller/ledger branch changes across the matched hybrid modes.
U=size(tape.attempt,2);L=size(c.ld,1);steps=size(tape.attempt,1);
idle=true(U,1);ordinal=zeros(U,1);queue=cell(L,1);active=zeros(L,1);
% Columns: user, arrival, submit, inclusion, acceptance, decision, start, end,
% payload, x,y,z, LD, status, remaining. Status 0 pending; 2 queued; 4 active;
% 5 complete; -1 capacity rejection; -2 optical coverage rejection.
rows=nan(10000,15);H=zeros(10000,L);N=0;tx=zeros(0,5);cursor=1;
block=ceil(tape.block_times/c.dt)*c.dt;
ledger=strcmp(c.mode,'ledger');
for step=1:steps
    now=(step-1)*c.dt;
    ask=find(idle & tape.attempt(step,:)'<=c.traffic_probability);
    for uid=ask'
        N=N+1;ordinal(uid)=ordinal(uid)+1;j=ordinal(uid);
        if N>size(rows,1),rows(end+10000,15)=NaN;H(end+10000,L)=0;end
        pos=[10*tape.x(j,uid),10*tape.y(j,uid),1];
        bits=(1+9*tape.payload(j,uid))*1e9;
        [~,ld]=min(sum((c.ld-pos).^2,2));
        rows(N,:)=[uid,now,now+c.control_transport_s,NaN,NaN,NaN,NaN,NaN,bits,pos,ld,0,bits];
        H(N,:)=optical_channel_r3(pos,c.ld,c);idle(uid)=false;
    end
    if ledger
        while block(cursor)<=now+1e-9
            eligible=find(rows(1:N,14)==0 & rows(1:N,3)<=block(cursor)+1e-9);
            eligible=eligible(1:min(numel(eligible),c.batch_size*c.transactions_per_block));
            for first=1:c.batch_size:numel(eligible)
                ids=eligible(first:min(first+c.batch_size-1,numel(eligible)));
                acc=ceil((block(cursor+c.confirmations)+c.assignment_read_s)/c.dt)*c.dt;
                tx(end+1,:)=[block(cursor),acc,numel(ids),132+128*numel(ids),cursor]; %#ok<AGROW>
            end
            for k=eligible'
                rows(k,4)=block(cursor);
                rows(k,5)=ceil((block(cursor+c.confirmations)+c.assignment_read_s)/c.dt)*c.dt;
                admit(k,now);
            end
            cursor=cursor+1;
        end
    else
        ready=find(rows(1:N,14)==0 & rows(1:N,3)<=now+1e-9);
        for k=ready'
            rows(k,5)=ceil((now+c.assignment_read_s)/c.dt)*c.dt;
            admit(k,now);
        end
    end
    for ld=1:L
        if active(ld)==0 && ~isempty(queue{ld})
            k=queue{ld}(1);
            if rows(k,5)<=now+1e-9,active(ld)=k;rows(k,14)=4;rows(k,7)=now;end
        end
    end
    busy=find(active>0);interval=min(c.dt,c.horizon-now);
    if isempty(busy) || interval<=0,continue;end
    ids=active(busy);g=H(ids,busy);
    signal=diag(g).^2*c.optical_power_w^2*c.responsivity_a_w^2;
    interference=max(0,sum(g.^2,2)*c.optical_power_w^2*c.responsivity_a_w^2-signal);
    rate=c.optical_bandwidth_hz*log2(1+signal./(c.optical_bandwidth_hz*c.noise_psd_a2_hz+interference));
    assert(all(isfinite(rate) & rate>0));
    for j=1:numel(busy)
        ld=busy(j);k=ids(j);
        if rows(k,15)<=interval*rate(j)
            rows(k,8)=now+rows(k,15)/rate(j);rows(k,15)=0;rows(k,14)=5;
            idle(rows(k,1))=true;queue{ld}(1)=[];active(ld)=0;
        else,rows(k,15)=rows(k,15)-interval*rate(j);end
    end
end
rows=rows(1:N,:);H=H(1:N,:); %#ok<NASGU>
done=rows(:,14)==5;inc=isfinite(rows(:,4));accepted=rows(:,14)>=2;
assert(sum(done)+sum(rows(:,14)<0)+sum(rows(:,14)>=0 & ~done)==N);
assert(all(rows(done,7)>=rows(done,5)-1e-9));
assert(all(rows(done,8)>=rows(done,7) & rows(done,8)<=c.horizon+1e-9));
assert(sum(cellfun(@numel,queue))==sum(rows(:,14)==2 | rows(:,14)==4));
m=struct('offered',N,'completed',sum(done),'admitted',sum(accepted),...
    'unfinished',sum(rows(:,14)>=0 & ~done),'queue_rejected',sum(rows(:,14)==-1),...
    'coverage_rejected',sum(rows(:,14)==-2),'rejection_fraction',sum(rows(:,14)<0)/max(1,N),...
    'goodput_gbps',sum(rows(done,9))/c.horizon/1e9,...
    'access_mean_s',avg(rows(done,7)-rows(done,2)),...
    'access_p95_s',pct(rows(done,7)-rows(done,2),.95),...
    'completion_mean_s',avg(rows(done,8)-rows(done,2)),...
    'completion_p95_s',pct(rows(done,8)-rows(done,2),.95),...
    'transport_mean_s',avg(rows(done,3)-rows(done,2)),...
    'inclusion_mean_s',avg(rows(done,4)-rows(done,3)),...
    'confirmation_mean_s',avg(rows(done,5)-rows(done,4)-c.assignment_read_s),...
    'queue_mean_s',avg(rows(done,7)-rows(done,5)),...
    'payload_mean_s',avg(rows(done,8)-rows(done,7)),...
    'included_transactions_s',size(tx,1)/c.horizon,...
    'included_requests_s',sum(tx(:,3))/c.horizon,...
    'offered_requests_s',N/c.horizon,'completion_requests_s',sum(done)/c.horizon,...
    'pending_inclusion',sum(rows(:,14)==0),'pending_confirmation',sum(rows(:,14)==2 & rows(:,5)>c.horizon),...
    'mean_block_s',mean(diff([0;tape.block_times(tape.block_times<=c.horizon)])));
if ~ledger,m.inclusion_mean_s=0;m.confirmation_mean_s=0;end
r=struct('metrics',m,'records',rows,'transactions',tx,'cfg',c);
    function admit(k,t)
        target=rows(k,13);rows(k,6)=t;
        if numel(queue{target})>=c.capacity,rows(k,14)=-1;idle(rows(k,1))=true;
        elseif H(k,target)<=0,rows(k,14)=-2;idle(rows(k,1))=true;
        else,queue{target}(end+1)=k;rows(k,14)=2;end
    end
end
function v=avg(x)
if isempty(x),v=NaN;else,v=mean(x);end
end
function v=pct(x,p)
x=sort(x);if isempty(x),v=NaN;else,v=x(max(1,ceil(numel(x)*p)));end
end
