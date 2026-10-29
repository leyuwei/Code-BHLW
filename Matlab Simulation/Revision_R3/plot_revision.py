from pathlib import Path
import subprocess,sys
here=Path(__file__).resolve().parent;repo=here.parents[1];out=here/'results/figures'
commands=[['wifi.py',out/'wifi'],['matched.py',out/'matched'],
          ['policy.py',here/'results/revision32/matlab',repo/'verification/results/r26_policy',out/'policy'],
          ['latency.py',here/'results/revision26',here/'results/revision25/matlab',out/'latency']]
for name,*args in commands:subprocess.run([sys.executable,str(here/'plots'/name),*map(str,args)],check=True)
print('PASS: current WiFi, coordination-failure, AP-policy and confirmation figures.')
