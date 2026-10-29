"""Independent request, queue, timing and optical-bit checks for all 255 failure runs."""
from pathlib import Path
import json,math
import numpy as np
import pandas as pd
from scipy.io import loadmat
project=Path(__file__).resolve().parents[1]/'Matlab Simulation/Revision_R3'
out=project/'results/revision32/matlab'
c=json.loads((out/'configuration.json').read_text());ld=np.asarray(c['ld'])
expected=json.loads((project/'results/revision25/matlab/hybrid_configuration.json').read_text())
expected={k:v for k,v in expected.items()if k not in ['mode','traffic_probability']}
def percentile(x,p=.95):return np.sort(x)[max(0,math.ceil(len(x)*p)-1)]if len(x)else np.nan

def close(a,b):return np.allclose(a,b,rtol=1e-10,atol=1e-8,equal_nan=True)

def optical_gain(pos):
    distance2=((pos[:,None,:]-ld[None,:,:])**2).sum(axis=2)
    cosine=(ld[None,:,2]-pos[:,None,2])/np.sqrt(distance2)
    h=(c['lambertian_order']+1)*c['pd_area_m2']/(2*np.pi*distance2)*cosine**(c['lambertian_order']+1)
    h[(cosine<np.cos(np.deg2rad(c['fov_deg'])))|(cosine<=0)]=0
    return h

def optical_integral(a,h):
    """Independent bit accounting using the published channel and start/finish events."""
    ids=np.flatnonzero(np.isfinite(a[:,6]));events={0.:[],float(c['horizon']):[]}
    for k in ids:
        start=round(float(a[k,6]),8)
        stop=math.ceil((a[k,7]-1e-8)/c['dt'])*c['dt']if np.isfinite(a[k,7])else c['horizon']
        stop=round(min(stop,c['horizon']),8)
        events.setdefault(start,[]).append((1,k));events.setdefault(stop,[]).append((-1,k))
    times=sorted(events);active={};bits=np.zeros(len(a))
    for j,t in enumerate(times[:-1]):
        for kind,k in sorted(events[t]):
            target=int(a[k,12])-1
            if kind==-1:
                assert active.get(target)==k;del active[target]
            else:
                assert target not in active;active[target]=k
        if not active:continue
        lights=np.array(list(active),dtype=int);jobs=np.array([active[x]for x in lights],dtype=int)
        gains=h[np.ix_(jobs,lights)]
        power=gains**2*c['optical_power_w']**2*c['responsivity_a_w']**2
        signal=np.diag(power);interference=np.maximum(0,power.sum(axis=1)-signal)
        rates=c['optical_bandwidth_hz']*np.log2(1+signal/(c['optical_bandwidth_hz']*c['noise_psd_a2_hz']+interference))
        ends=np.where(np.isfinite(a[jobs,7]),a[jobs,7],c['horizon'])
        duration=np.maximum(0,np.minimum(times[j+1],ends)-t)
        bits[jobs]+=rates*duration
    expected_bits=a[ids,8]-a[ids,14]
    assert np.allclose(bits[ids],expected_bits,rtol=2e-8,atol=300),np.max(abs(bits[ids]-expected_bits))
    return len(ids),float(np.max(abs(bits[ids]-expected_bits),initial=0))

base_blocks={seed:np.asarray(loadmat(project/f'results/revision25/matlab/tape_seed{seed}.mat',simplify_cells=True)['tape']['block_times']).reshape(-1)for seed in range(1,6)}
cache={};checked_records=0;optical_checks=[];paths=sorted((out/'traces').glob('*.mat'))
assert len(paths)==255
for index,path in enumerate(paths):
    x=loadmat(path,simplify_cells=True);r=x['r'];v=x['value'];a=np.atleast_2d(r['records']);cfg=r['cfg'];m=r['metrics']
    assert all(close(cfg[k],value) for k,value in expected.items())
    users=50;seed=int(v['seed']);duty=v['outage_duty'];mode=v['mode']
    assert cfg['mode']==mode and cfg['outage_duty']==duty
    assert cfg['traffic_probability']==v['traffic_probability']and cfg['miners']==273
    assert (a[:,0]>=1).all()and(a[:,0]<=users).all()
    assert np.all((a[:,8]>=1e9)&(a[:,8]<=1e10))
    assert np.all((a[:,9:11]>=0)&(a[:,9:11]<=10))and np.all(a[:,11]==1)
    assert np.all((a[:,14]>=-1e-8)&(a[:,14]<=a[:,8]+1e-8))
    status=a[:,13];done=status==5;admitted=status>=2;decided=np.isfinite(a[:,5])
    assert set(status)<=set([-2,-1,0,2,4,5])
    assert len(a)==sum(done)+sum(status<0)+sum((status>=0)&~done)
    nearest=((a[:,None,9:12]-ld[None,:,:])**2).sum(axis=2).argmin(axis=1)+1
    assert np.array_equal(nearest,a[:,12])
    h=optical_gain(a[:,9:12]);queues={i:[]for i in range(1,26)}
    for k in sorted(np.flatnonzero(decided),key=lambda k:(a[k,5],k)):
        now=a[k,5];target=int(a[k,12]);queues[target]=[j for j in queues[target]if not np.isfinite(a[j,7])or a[j,7]>now+1e-9]
        if mode!='ledger'and duty:assert now%120<120*(1-duty)-1e-8
        if len(queues[target])>=3:assert status[k]==-1
        elif h[k,target-1]<=0:assert status[k]==-2
        else:assert status[k]>=2;queues[target].append(k)
    for uid in np.unique(a[:,0]).astype(int):
        indices=np.flatnonzero(a[:,0]==uid);values=a[indices][:,[8,9,10,11]];key=(seed,uid)
        if key in cache:
            n=min(len(values),len(cache[key]));assert np.array_equal(values[:n],cache[key][:n])
        if key not in cache or len(values)>len(cache[key]):cache[key]=values.copy()
        for i,k in zip(indices[:-1],indices[1:]):
            finish=a[i,7]if status[i]==5 else a[i,5]
            assert np.isfinite(finish)and a[k,1]>=finish-1e-9
    assert np.all(a[done,6]>=a[done,4]-1e-9)
    assert np.all(a[done,7]<=c['horizon']+1e-9)
    checks=dict(offered=len(a),completed=sum(done),admitted=sum(admitted),unfinished=sum((status>=0)&~done),
                queue_rejected=sum(status==-1),coverage_rejected=sum(status==-2),
                rejection_fraction=sum(status<0)/len(a),goodput_gbps=a[done,8].sum()/c['horizon']/1e9,
                access_mean_s=np.mean(a[done,6]-a[done,1]),access_p95_s=percentile(a[done,6]-a[done,1]),
                completion_mean_s=np.mean(a[done,7]-a[done,1]),completion_p95_s=percentile(a[done,7]-a[done,1]),
                payload_mean_s=np.mean(a[done,7]-a[done,6]),queue_mean_s=np.mean(a[done,6]-a[done,4]),
                transport_mean_s=np.mean(a[done,2]-a[done,1]),dispatch_mean_s=np.mean(a[done,5]-a[done,2]),
                confirmation_mean_s=np.mean(a[done,15]),retrieval_mean_s=np.mean(a[done,4]-a[done,5]-a[done,15]))
    blocks=base_blocks[seed]
    if mode=='ledger':
        effective=120*(1-duty/273);cycles=np.floor(blocks/effective);remainder=blocks-cycles*effective;up=120*(1-duty)
        blocks=cycles*120+np.where(remainder<=up,remainder,up+(remainder-up)/(1-1/273))if duty else blocks
        included=np.isfinite(a[:,3]);rounded=np.ceil(blocks/.1)*.1
        assert np.all(np.isclose(a[included,3],rounded[np.searchsorted(rounded,a[included,3])],rtol=0,atol=1e-8))
        checks['inclusion_mean_s']=np.mean(a[done,3]-a[done,2])
    else:checks['inclusion_mean_s']=0
    accepted_blocks=blocks[blocks<=c['horizon']]
    checks['mean_block_s']=np.mean(np.diff(np.r_[0,accepted_blocks]))
    transactions=np.asarray(r['transactions']).reshape(-1,5)
    checks['included_transactions_s']=len(transactions)/c['horizon']
    checks['included_requests_s']=transactions[:,2].sum()/c['horizon']
    for key,value in checks.items():assert close(value,m[key]),(path.name,key,value,m[key])
    assert close(m['completion_mean_s'],m['access_mean_s']+m['payload_mean_s'])
    if seed==1 and np.isclose(v['request_frequency_s'],.1)and duty in [0,.1,.7,.8]:
        count,error=optical_integral(a,h);optical_checks.append(dict(file=path.name,jobs=count,max_bit_error=error))
    checked_records+=len(a)
    if (index+1)%90==0:print('Verified',index+1,'of',len(paths),'traces',flush=True)

assert len(optical_checks)==12
report=dict(passed=True,trace_files=len(paths),request_records_checked=checked_records,independent_optical_integrations=len(optical_checks),optical_checks=optical_checks)
(out/'independent_trace_validation.json').write_text(json.dumps(report,indent=2),'utf-8')
print('PASS:',len(paths),'traces;',checked_records,'requests;',len(optical_checks),'independent optical integrations')
