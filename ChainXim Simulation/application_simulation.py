"""Communication application on the supplied ChainXim consensus/network core.

Rates are bit/s, payloads bits, positions metres and times seconds. The
dedicated-chain simulation carries its application list in simulated blocks;
the Ethereum implementation uses contract storage and receipt events.
"""
from pathlib import Path
from collections import deque
import configparser,csv,json,math
import numpy as np

def optical_gains(position,ld):
    distance2=((np.asarray(position)-ld)**2).sum(axis=1)
    cosine=(ld[:,2]-position[2])/np.sqrt(distance2)
    return np.where(cosine>=math.cos(math.pi/6),11e-4/(2*math.pi*distance2)*cosine**11,0.)

def wifi_rate(position,rng,ap_position=(5,5,0)):
    distance=np.linalg.norm(np.asarray(position)-ap_position)
    sigma=3 if distance<=5 else 5
    loss=20*math.log10(distance)+20*math.log10(5e9)-147.5+35*math.log10(max(distance/5,1))+sigma*rng.normal()
    scatter=(rng.normal()+1j*rng.normal())/math.sqrt(2)
    gain=abs(math.sqrt(.5)+math.sqrt(.5)*scatter)**2*10**(-loss/10)
    return 40e6*math.log2(1+gain/(40e6*1.380649e-23*288.15))

def run_application(environment,num_rounds,max_height,scenario):
    import global_var
    from data import Block
    config=configparser.ConfigParser();config.read('system_config.ini',encoding='utf-8')
    settings=config['ApplicationSettings'];seed=settings.getint('seed');rng=np.random.default_rng(seed)
    dt=settings.getfloat('round_interval');users=settings.getint('user_count');probability=settings.getfloat('traffic_probability')
    assert dt==.1 and users>=1 and 0<=probability<=1
    assert environment.adversary.get_adver_num()==0,'This paper configuration uses zero adversarial miners.'
    ledger=scenario!='WiFi-baseline2';optical=scenario=='OWC'
    if ledger:assert environment.miner_num==273
    ld_count=settings.getint('ld_count',fallback=25);side=math.isqrt(ld_count)
    assert side*side==ld_count and side>=1,'LD count must form an evenly spaced square grid.'
    axis=(np.arange(side)+.5)*10/side
    ld=np.array([[x,y,3.]for y in axis for x in axis])
    queues=[deque()for _ in range(ld_count if optical else 1)];pending=deque();records=[];idle=np.ones(users,dtype=bool)
    confirmations=settings.getint('confirmations');assert confirmations==0
    block_times=[];last_height=0;time=0.;total_steps=0
    for round_number in range(1,num_rounds+1):
        time=round_number*dt;total_steps=round_number
        for uid in np.flatnonzero(idle & (rng.random(users)<probability)):
            position=[10*rng.random(),10*rng.random(),1.]
            target=int(((ld-position)**2).sum(axis=1).argmin())if optical else 0
            bits=rng.uniform(1e9,1e10)
            row=dict(request=len(records),user_id=int(uid+1),arrival_s=time,position=position,ld=target+1,
                     payload_bits=bits,remaining_bits=bits,status='pending',inclusion_s=None,start_s=None,completion_s=None)
            records.append(row);pending.append(row['request']);idle[uid]=False
        eligible=[i for i in pending if records[i]['arrival_s']<=time-dt+1e-8][:80]
        occupancy=[len(q)for q in queues];decisions={};service_lists={f'LD{i+1}':[]for i in range(len(queues))}
        for index in eligible:
            row=records[index];target=row['ld']-1 if optical else 0
            covered=not optical or optical_gains(row['position'],ld)[target]>0
            reason='capacity'if occupancy[target]>=(3 if optical else 15)else 'coverage'if not covered else 'accepted'
            decisions[index]=reason
            if reason=='accepted':occupancy[target]+=1;service_lists[f'LD{target+1}'].append(index)
        included=[]
        if ledger:
            service={'requests':eligible,'service_lists':service_lists,'decisions':decisions}
            for miner in environment.miners:
                miner.input_tape.extend([('INSERT',round_number),('SERVICE',service)])
                messages=miner.BackboneProtocol(round_number)
                for message in messages or []:
                    if isinstance(message,Block):environment.global_chain._add_block_forcibly(message)
                miner.clear_tapes()
            environment.network.diffuse(round_number)
            height=environment.global_chain.get_height()
            if height>last_height:
                block=environment.global_chain.get_last_block()
                included=block.servicelists.get('requests',[]);decisions=block.servicelists.get('decisions',{})
                block_times.append(time);last_height=height
        else:included=eligible; height=0
        for index in included:
            row=records[index]
            if row['status']!='pending':continue
            pending.remove(index);row['inclusion_s']=time;row['inclusion_height']=height;row['ready_s']=time+dt
            queue=queues[row['ld']-1]if optical else queues[0]
            reason=decisions[index]
            if reason=='capacity':row['status']='rejected_capacity'
            elif reason=='coverage':row['status']='rejected_coverage'
            else:
                row['status']='queued';queue.append(index)
                if not optical:row['rate_bps']=wifi_rate(row['position'],rng)
            if row['status'].startswith('rejected'):idle[row['user_id']-1]=True
        active=[]
        for queue in queues:
            for index in list(queue)[:1 if optical else 12]:
                row=records[index]
                if row['ready_s']>time+1e-8 or (ledger and height-row['inclusion_height']<confirmations):continue
                if row['start_s']is None:row['start_s']=time
                row['status']='serving';active.append(index)
        if optical and active:
            lights=np.array([records[i]['ld']-1 for i in active])
            gains=np.array([optical_gains(records[i]['position'],ld)[lights]for i in active])
            power=(13*gains)**2;signal=np.diag(power)
            rates=100e6*np.log2(1+signal/(100e6*1e-21+np.maximum(0,power.sum(axis=1)-signal)))
        else:rates=[records[i]['rate_bps']for i in active]
        duration=max(0.,min(dt,num_rounds*dt-time))
        for index,rate in zip(active,rates):
            row=records[index];assert math.isfinite(rate)and rate>0
            if row['remaining_bits']<=duration*rate:
                row['completion_s']=time+row['remaining_bits']/rate;row['remaining_bits']=0;row['status']='completed'
                (queues[row['ld']-1]if optical else queues[0]).remove(index);idle[row['user_id']-1]=True
            else:row['remaining_bits']-=duration*rate
        if ledger and height>=max_height:break
    elapsed=min(num_rounds*dt,(total_steps+1)*dt)
    completed=[r for r in records if r['status']=='completed']
    rejected=[r for r in records if r['status'].startswith('rejected')]
    unfinished=[r for r in records if r['status']not in ['completed','rejected_capacity','rejected_coverage']]
    assert len(completed)+len(rejected)+len(unfinished)==len(records)
    assert all(len(q)<=(3 if optical else 15)for q in queues)
    metrics=dict(scenario=scenario,seed=seed,rounds=total_steps,elapsed_s=elapsed,offered=len(records),
        completed=len(completed),rejected=len(rejected),unfinished=len(unfinished),
        goodput_gbps=sum(r['payload_bits']for r in completed)/elapsed/1e9,
        rejection_fraction=len(rejected)/max(1,len(records)),blocks=len(block_times),
        mean_block_s=float(np.mean(np.diff([0,*block_times])))if block_times else None)
    output=global_var.get_result_path();output.mkdir(parents=True,exist_ok=True)
    (output/'application_summary.json').write_text(json.dumps(metrics,indent=2),'utf-8')
    parameters=dict(room_m=[10,10,3],users=users,ld_positions=ld.tolist()if optical else [],
        dt_s=dt,traffic_probability=probability,payload_bits=[1e9,1e10],ld_power_w=13,
        rf_carrier_hz=5e9,rf_channels=12,rf_bandwidth_hz=40e6,rf_power_w=1,
        capacity_per_ld=3,wifi_extra_waiting_capacity=3,confirmations=confirmations,
        block_request_capacity=80,consensus='ChainXim PoW'if ledger else 'centralized scheduling',
        miners=environment.miner_num if ledger else 0,adversaries=0,
        hash_trials_per_miner=config.getint('ConsensusSettings','q_ave')if ledger else 0)
    (output/'application_configuration.json').write_text(json.dumps(parameters,indent=2),'utf-8')
    with (output/'requests.csv').open('w',newline='',encoding='utf-8')as stream:
        fields=['request','user_id','arrival_s','position','ld','payload_bits','status','inclusion_s','start_s','completion_s']
        writer=csv.DictWriter(stream,fieldnames=fields,extrasaction='ignore');writer.writeheader();writer.writerows(records)
    environment.total_round=total_steps;environment.application_summary=metrics
    print(json.dumps(metrics));return metrics
