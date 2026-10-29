"""Reply-only AP policy/aggregate-monitor study using the existing verifier.

Synthetic enrolled identities and public test keys; deterministic seeds retain
the complete request generator. Aggregate alarms guide AP intervention.
"""
from pathlib import Path
from collections import deque, Counter
from bisect import bisect_right
import csv, hashlib, hmac, json, math, platform, random, statistics, sys, time

ROOT=Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT.parent))
from ap_policy import APPolicy,sign

KEY=b'PUBLIC-RESPONSE-R25-SYNTHETIC-TEST-KEY'
NAMES=[*[f'u{i}' for i in range(50)],*[f'a{i}' for i in range(100)],'flood','replay','forge','stale','outside','burst']
KEYS={s:hmac.new(KEY,s.encode(),hashlib.sha256).digest() for s in NAMES}

def req(uid,nonce,t,pos=None):
    return sign(dict(user_id=uid,nonce=nonce,issued_ms=round(t*1000),position=pos or [2,2,1]),KEYS[uid])

def trace(seed,legit_rate,attack_rate,profile,burst_size=8):
    rng=random.Random(seed);events=[];counter=Counter()
    def add(t,uid,attack,kind,request=None):
        counter[uid]+=1
        events.append((t,attack,kind,request or req(uid,counter[uid],t)))
    t=0
    while True:
        t+=rng.expovariate(legit_rate)
        if t>=400:break
        add(t,f'u{rng.randrange(50)}',False,'normal')
    for base in (40,160,340):
        for j in range(burst_size):add(base+j*.05,'burst',False,'legitimate_burst')
    if profile=='replay':
        for j in range(20):
            at=100+10*j
            add(at,'replay',False,'replay_original',req('replay',j,at))
    t=100;i=0
    while True:
        t+=rng.expovariate(attack_rate)
        if t>=300:break
        uid='flood';request=None
        if profile=='distributed':uid=f'a{i%100}'
        elif profile=='forged':
            uid='forge';request=req(uid,i,t);request['tag']='00'*32
        elif profile=='replay':
            uid='replay';j=int((t-100)//10);request=req(uid,j,100+10*j)
        elif profile=='stale':uid='stale';request=req(uid,i,t-120)
        elif profile=='outside_room':uid='outside';request=req(uid,i,t,[11,2,1])
        add(t,uid,True,profile,request);i+=1
    events.sort(key=lambda x:x[0])
    return events

def evaluate(events,limit,save=None):
    p=APPolicy(KEYS,limit=limit,window_s=10,freshness_s=30)
    counts=Counter();kind=Counter();times=[];valid=[];decisions=[]
    for t,attack,name,request in events:
        start=time.perf_counter_ns();allowed,reason=p.evaluate(request,t)
        times.append((time.perf_counter_ns()-start)/1000)
        code=('fn' if allowed else 'tp') if attack else ('tn' if allowed else 'fp')
        counts[code]+=1;kind[(name,code)]+=1
        if reason in ('accepted','rate_limit'):valid.append(t)
        if save is not None:decisions.append(dict(time_s=t,attack=int(attack),kind=name,allowed=int(allowed),reason=reason))
    if save is not None:write_csv(save,decisions)
    tp,fn,fp,tn=(counts[x] for x in ('tp','fn','fp','tn'))
    result=dict(requests=len(events),tp=tp,fn=fn,fp=fp,tn=tn,
                accuracy=(tp+tn)/len(events),recall=tp/(tp+fn),
                precision=tp/(tp+fp) if tp+fp else 0,false_alarm_rate=fp/(fp+tn),
                ap_processing_p50_us=statistics.median(times),
                ap_processing_p95_us=sorted(times)[math.ceil(.95*len(times))-1])
    for threshold in (20,30,40,60,80):
        alarms={t:bisect_right(valid,t)-bisect_right(valid,t-10)>threshold for t in range(10,400)}
        active=list(range(110,300));benign=list(range(10,100))+list(range(310,400))
        first=next((t for t in range(100,300) if alarms[t]),None)
        result[f'monitor_{threshold}_recall']=statistics.mean(alarms[t] for t in active)
        result[f'monitor_{threshold}_false_alarm']=statistics.mean(alarms[t] for t in benign)
        result[f'monitor_{threshold}_first_delay_s']=None if first is None else first-100
    return result

def write_csv(path,rows):
    with path.open('w',newline='',encoding='utf-8') as f:
        w=csv.DictWriter(f,fieldnames=rows[0]);w.writeheader();w.writerows(rows)

def checks():
    replay=trace(1,1,5,'replay');x=evaluate(replay,3)
    assert x['recall']==1
    for name in ('forged','stale','outside_room'):
        assert evaluate(trace(1,1,5,name),3)['recall']==1
    e=trace(1,1,5,'distributed');x=evaluate(e,3)
    assert x['recall']==0 and x['monitor_40_recall']>.9
    assert all(a[0]<=b[0] for a,b in zip(e,e[1:]))


if __name__=='__main__':
    output=Path(sys.argv[1]);output.mkdir(parents=True,exist_ok=True)
    checks();start=time.time();rows=[]
    attacks=[.25,.5,.75,1,1.5,2,3,4,5,7.5,10,15,20,30,40]
    normal=[.1,.2,.3,.5,.7,1,1.5,2,3,4,5,6,8,10]
    def run(seed,legit,attack,profile,allowance,burst,sweep,events):
        result=evaluate(events,allowance)
        rows.append(dict(seed=seed,legitimate_rate_s=legit,attack_rate_s=attack,profile=profile,allowance=allowance,burst_size=burst,sweep=sweep,**result))
    for seed in range(1,6):
        for attack in attacks:
            for profile in ('flood','distributed','forged','replay','stale','outside_room'):
                events=trace(seed,1,attack,profile)
                for allowance in range(1,13):run(seed,1,attack,profile,allowance,8,'attack',events)
        for burst in (2,4,8,12,20):
            events=trace(seed,1,5,'flood',burst)
            for allowance in range(1,13):run(seed,1,5,'flood',allowance,burst,'burst',events)
        for legit in normal:
            for attack in attacks:
                events=trace(seed,legit,attack,'distributed')
                run(seed,legit,attack,'distributed',3,8,'aggregate',events)
        write_csv(output/'policy_runs.csv',rows)
        print('Seed',seed,'complete;',len(rows),'conditions',flush=True)
    report=dict(passed=True,runs=len(rows),seeds=5,attack_rates=attacks,normal_rates=normal,allowances=list(range(1,13)),burst_sizes=[2,4,8,12,20],aggregate_thresholds=[20,30,40,60,80],window_s=10,inspection_s=1,horizon_s=400,attack_interval_s=[100,300],elapsed_s=time.time()-start,runtime=dict(python=sys.version.split()[0],processor=platform.processor()))
    (output/'validation.json').write_text(json.dumps(report,indent=2),encoding='utf-8')
    print(json.dumps(report))
