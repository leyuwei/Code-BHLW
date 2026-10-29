"""Execute all three ChainXim applications and check their paper parameters."""
from pathlib import Path
import importlib.util,subprocess,sys,json,math,csv,hashlib,configparser
import numpy as np

root=Path(__file__).resolve().parents[1];base=root/'ChainXim Simulation'
out=Path(__file__).parent/'results/chainxim';out.mkdir(parents=True,exist_ok=True)
spec=importlib.util.spec_from_file_location('application_simulation',base/'application_simulation.py')
module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
ld=np.array([[x,y,3.]for y in [1,3,5,7,9]for x in [1,3,5,7,9]])
expected=11e-4/(8*math.pi)
assert np.isclose(module.optical_gains([1,1,1],ld)[0],expected,rtol=1e-14)
assert module.optical_gains([9,9,1],ld)[0]==0
distance=((ld-[2,1,1])**2).sum(axis=1);assert np.argmin(distance)==0 and distance[0]==distance[1]
rng=np.random.default_rng(71)
rates=[12*module.wifi_rate([10*rng.random(),10*rng.random(),1],rng)/1e9 for _ in range(30000)]
assert abs(np.mean(rates)-10.8)<.08
metrics=[]
configuration=configparser.ConfigParser();configuration.read(base/'OWC/system_config.ini')
target=int(configuration['ConsensusSettings']['target'],16)/2**256
probability=-math.expm1(273*2*math.log1p(-target))
assert abs(.1/probability-12)<1e-8
for scenario in ['OWC','WiFi-baseline1','WiFi-baseline2']:
    target=out/scenario
    args=[sys.executable,str(base/scenario/'main.py'),'--total_round','18000','--total_height','10000','--result_path',str(target)]
    result=subprocess.run(args,capture_output=True,timeout=180)
    (out/(scenario+'.log')).write_bytes(result.stdout+result.stderr)
    assert result.returncode==0,(scenario,(result.stdout+result.stderr).decode('utf-8',errors='replace')[-2000:])
    values=json.loads((target/'application_summary.json').read_text());c=json.loads((target/'application_configuration.json').read_text())
    assert values['elapsed_s']==1800 and values['rounds']==18000
    assert values['completed']+values['rejected']+values['unfinished']==values['offered']
    assert c['users']==50 and c['dt_s']==.1 and c['payload_bits']==[1e9,1e10]
    assert c['ld_power_w']==13 and c['rf_carrier_hz']==5e9 and c['rf_channels']==12
    assert c['capacity_per_ld']==3 and c['confirmations']==0 and c['adversaries']==0
    if scenario=='OWC':assert len(c['ld_positions'])==25
    if scenario=='WiFi-baseline2':assert values['blocks']==0 and c['miners']==0
    else:assert values['blocks']>0 and c['miners']==273
    with (target/'requests.csv').open(encoding='utf-8')as stream:requests=list(csv.DictReader(stream))
    assert len(requests)==values['offered']
    for row in requests:
        assert 1e9<=float(row['payload_bits'])<=1e10
        if row['status']=='completed':
            assert float(row['arrival_s'])<=float(row['inclusion_s'])<=float(row['start_s'])<=float(row['completion_s'])<=1800+1e-8
    metrics.append(values);print(scenario,'PASS',values,flush=True)
report=dict(passed=True,full_timeline_runs=3,rf_reference_gbps=float(np.mean(rates)),
            expected_block_interval_s=.1/probability,optical_gain_check=True,nearest_ld_tie_check=True,results=metrics,
            scope='Fresh application executions with the supplied ChainXim core; submitted figures are unchanged.')
(out/'verification.json').write_text(json.dumps(report,indent=2),'utf-8')
