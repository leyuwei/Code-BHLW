from pathlib import Path
from collections import Counter
import csv,hashlib,hmac,json,math,random,statistics,time,sys
from ap_policy import APPolicy,sign

ROOT=Path(__file__).resolve().parent
OUT=ROOT/'results/policy';OUT.mkdir(parents=True,exist_ok=True)
KEY=b'R3-TEST-ONLY-KEY-DO-NOT-DEPLOY'
keys={name:hmac.new(KEY,name.encode(),hashlib.sha256).digest() for name in
      [*[f'benign{i}' for i in range(10)],'burst','flood','replay','forged',*[f'sybil{i}' for i in range(10)]]}
def request(uid,nonce,t,position=None):
    return sign({'user_id':uid,'nonce':nonce,'issued_ms':round(t*1000),
                 'position':position if position is not None else [2,2,1]},keys[uid])

def checks():
    p=APPolicy(keys);valid=request('benign0',0,0)
    assert p.evaluate(valid,0)==(True,'accepted')
    assert p.evaluate(valid,0)==(False,'replay')
    tampered=request('benign0',1,0);tampered['body']['position'][0]=8
    assert p.evaluate(tampered,0)==(False,'authentication')
    assert p.evaluate(request('benign0',2,0,[11,0,1]),0)==(False,'invalid_position')
    assert p.evaluate(request('benign0',3,0),31)==(False,'freshness')
    p=APPolicy(keys,limit=1,window_s=10)
    assert p.evaluate(request('benign0',1,0),0)[0]
    assert p.evaluate(request('benign0',2,9),9)==(False,'rate_limit')
    assert p.evaluate(request('benign0',3,10),10)[0]
    assert p.evaluate(request('benign0',2,9),10)==(False,'replay')
    assert p.evaluate([],10)==(False,'malformed_request')
    assert p.evaluate({'body':[]},10)==(False,'malformed_request')
    assert p.evaluate({'body':{'user_id':[]}},10)==(False,'unknown_identity')
    bad=request('benign0',4,10);bad['tag']='不是合法的认证码'
    assert p.evaluate(bad,10)==(False,'authentication')
    p=APPolicy(keys,limit=2,window_s=10)
    for nonce,t in enumerate([.03,5.03,10.03]):assert p.evaluate(request('benign0',nonce,t),t)[0]
    return 16

def experiment(limit=3):
    cases=[]
    def add(t,uid,nonce,kind,attack=False,req=None):
        cases.append({'t':t,'uid':uid,'kind':kind,'attack':attack,'request':req or request(uid,nonce,t)})
    for i in range(10):
        for n in range(12):add(i*.03+n*5,f'benign{i}',n,'normal')
    for n in range(8):add(20+n*.05,'burst',n,'benign_burst')
    for n in range(200):add(25+n*.05,'flood',n,'flood',True)
    original=request('replay',0,5);add(5,'replay',0,'normal',False,original)
    for n in range(20):add(6+n*.05,'replay',0,'replay',True,original)
    for n in range(10):
        req=request('forged',n,10+n*.05);req['tag']='00'*32
        add(10+n*.05,'forged',n,'forged_signature',True,req)
    for i in range(10):
        for n in range(2):add(40+i*.01+n,f'sybil{i}',n,'multi_identity_evasion',True)
    cases.sort(key=lambda x:x['t'])
    policy=APPolicy(keys,limit=limit);rows=[]
    for c in cases:
        start=time.perf_counter_ns();allowed,reason=policy.evaluate(c['request'],c['t'])
        elapsed=(time.perf_counter_ns()-start)/1000
        rows.append({'time_s':c['t'],'identity':c['uid'],'kind':c['kind'],'attack_label':c['attack'],
                     'allowed':allowed,'reason':reason,'ap_processing_us':elapsed})
    def score(subset):
        tp=sum(r['attack_label'] and not r['allowed'] for r in subset)
        fn=sum(r['attack_label'] and r['allowed'] for r in subset)
        fp=sum(not r['attack_label'] and not r['allowed'] for r in subset)
        tn=sum(not r['attack_label'] and r['allowed'] for r in subset)
        return {'requests':len(subset),'tp':tp,'fn':fn,'fp':fp,'tn':tn,
                'recall':tp/(tp+fn) if tp+fn else None,'false_alarm_fraction':fp/(fp+tn) if fp+tn else None}
    bykind={kind:score([r for r in rows if r['kind']==kind]) for kind in sorted({r['kind'] for r in rows})}
    assert bykind['replay']['recall']==1 and bykind['forged_signature']['recall']==1
    assert bykind['multi_identity_evasion']['recall']==0
    assert bykind['normal']['false_alarm_fraction']==0 and bykind['benign_burst']['fp']>0
    with (OUT/f'labeled_decisions_limit{limit}.csv').open('w',newline='',encoding='utf-8') as f:
        writer=csv.DictWriter(f,fieldnames=rows[0]);writer.writeheader();writer.writerows(rows)
    return {'policy':{'limit':limit,'window_s':10,'freshness_s':30},'overall':score(rows),'by_kind':bykind,
            'unfiltered_baseline':{'attack_recall':0,'false_alarm_fraction':0},
            'ap_processing_p95_us':sorted(r['ap_processing_us'] for r in rows)[math.ceil(.95*len(rows))-1],
            'limitations':['Synthetic labels; not captured wireless attack traffic.',
              'AP processing time excludes network transport, ledger delay and optical enforcement.',
              'A request quota is not an attack-intent classifier; legitimate bursts can be throttled.',
              'Distributed identities staying below each quota evade this policy.',
              'Test HMAC keys are public fixtures; no claim about production key provisioning.']}

def disclosure_experiment():
    rng=random.Random(61);records=[];epoch_s=10
    ld=[(x,y) for y in [2,5,8] for x in [2,5,8]]
    for uid in range(20):
        for session in range(20):
            t=session*3+uid*.01;x=rng.uniform(0,10);y=rng.uniform(0,10)
            index=min(range(len(ld)),key=lambda j:(x-ld[j][0])**2+(y-ld[j][1])**2)
            epoch=int(t//epoch_s)
            token=hmac.new(KEY,f'{uid}:{epoch}'.encode(),hashlib.sha256).hexdigest()[:32]
            records.append({'uid':uid,'time':t,'x':x,'y':y,'epoch':epoch,'token':token,'ld':index})
    total=linked=within=cross=0
    for i,a in enumerate(records):
        for b in records[i+1:]:
            if a['uid']!=b['uid']:continue
            total+=1;linked+=a['token']==b['token']
            if a['epoch']==b['epoch']:within+=1
            else:cross+=1
    rmse=math.sqrt(statistics.mean((r['x']-ld[r['ld']][0])**2+(r['y']-ld[r['ld']][1])**2 for r in records))
    public=[{'time_s':r['time'],'epoch':r['epoch'],'scoped_pseudonym':r['token'],'ld_id':r['ld']+1} for r in records]
    (OUT/'minimized_public_records.json').write_text(json.dumps(public,indent=2),encoding='utf-8')
    with (OUT/'metadata_ground_truth.csv').open('w',newline='',encoding='utf-8') as f:
        w=csv.DictWriter(f,fieldnames=records[0]);w.writeheader();w.writerows(records)
    assert linked==within and cross>0
    return {'records':len(records),'epoch_s':epoch_s,'same_user_pairs':total,
            'stable_id_token_equality_link_recall':1,'scoped_token_equality_link_recall':linked/total,
            'within_epoch_pairs_still_linked':within,'cross_epoch_same_user_pairs':cross,
            'public_exact_coordinate_rmse_m':0,'minimized_ld_center_predictor_rmse_m':rmse,
            'observer':'Knows LD coordinates and public time/LD/pseudonym; no private mapping or auxiliary trajectory.',
            'limitations':['Representation experiment, not an implemented private Ethereum allocator.',
              'Token equality is only one linkage rule; timing/trajectory attacks remain possible.',
              'The local revised Solidity ABI still publishes coordinates and IDs.',
              'Hidden coordinates require authorized off-chain allocation or a separately implemented verification protocol.']}

def export_contract_batch():
    # A small actual AP-to-Solidity interface check. Integer IDs/coordinates
    # follow the legacy ABI; this is not the synthetic attack population above.
    testkeys={str(i):hmac.new(KEY,str(i).encode(),hashlib.sha256).digest() for i in [1,2]}
    p=APPolicy(testkeys);admitted=[]
    for uid,nonce,position in [('1',1,[2,2,1]),('1',1,[2,2,1]),('2',1,[8,8,1])]:
        req=sign({'user_id':uid,'nonce':nonce,'issued_ms':0,'position':position},testkeys[uid])
        if p.evaluate(req,0)[0]:admitted.append(req['body'])
    assert [r['user_id'] for r in admitted]==['1','2']
    batch={'ids':[int(r['user_id']) for r in admitted],'coordinates':[r['position'] for r in admitted]}
    (OUT/'batch_to_contract.json').write_text(json.dumps(batch,indent=2),encoding='utf-8')
    return {'input_requests':3,'authenticated_nonreplayed_requests':2,'replay_excluded':True}

if __name__=='__main__':
    report={'runtime':{'python':sys.version.split()[0]},'unit_checks':checks(),'policy':experiment(),'policy_sensitivity':[experiment(k) for k in [2,6]],
            'metadata':disclosure_experiment(),'contract_bridge':export_contract_batch()}
    (OUT/'verification.json').write_text(json.dumps(report,indent=2),encoding='utf-8')
    print(json.dumps({'checks_passed':report['unit_checks'],'policy_requests':report['policy']['overall']['requests'],
                      'policy_recall':report['policy']['overall']['recall'],
                      'false_alarm_fraction':report['policy']['overall']['false_alarm_fraction'],
                      'distributed_attack_recall':report['policy']['by_kind']['multi_identity_evasion']['recall']}))
