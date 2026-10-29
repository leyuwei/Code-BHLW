"""Regression checks against the numeric results used by the submitted reply."""
from pathlib import Path
import json
import numpy as np
import pandas as pd

root=Path(__file__).resolve().parents[1]
base=root/'Matlab Simulation/Revision_R3/results';reference=Path(__file__).parent/'reference'
checks=[]
for actual,saved,keys,rows in [
    (base/'revision25/matlab/wifi_sensitivity.csv','wifi_sensitivity.csv',['scenario','seed'],80),
    (base/'revision26/matlab/wifi_correlation.csv','wifi_correlation.csv',['spatial','correlation','seed'],110),
    (base/'revision25/matlab/hybrid_runs.csv','hybrid_runs_r25.csv',['seed','traffic_probability','mode','experiment','capacity','confirmations'],160),
    (base/'revision26/matlab/hybrid_runs.csv','hybrid_runs.csv',['seed','traffic_probability','mode','experiment','capacity','confirmations'],570),
    (base/'revision32/matlab/runs.csv','outage_runs_v32.csv',['seed','traffic_probability','mode','outage_duty'],255)]:
    a=pd.read_csv(actual);b=pd.read_csv(reference/saved)
    assert len(a)==len(b)==rows
    assert not a.duplicated(keys).any()and not b.duplicated(keys).any()
    a=a.sort_values(keys).reset_index(drop=True);b=b.sort_values(keys).reset_index(drop=True)
    assert list(a.columns)==list(b.columns)
    for col in a.columns:
        if pd.api.types.is_numeric_dtype(a[col]):assert np.allclose(a[col],b[col],rtol=1e-12,atol=1e-10,equal_nan=True),(saved,col)
        else:assert a[col].equals(b[col]),(saved,col)
    checks.append(dict(file=saved,rows=rows,all_columns_equal=True))
gas=pd.read_csv(root/'Secure Communication Smart Contract/results/contract/gas.csv')
old=pd.read_csv(reference/'gas.csv')
for column in ['version','batch_size','state','gas','gas_per_request','calldata_bytes']:
    assert gas[column].equals(old[column]),column
checks.append(dict(file='gas.csv',rows=16,all_cost_and_calldata_values_equal=True))
report=dict(passed=True,checks=checks)
target=Path(__file__).parent/'results';target.mkdir(exist_ok=True)
(target/'regression.json').write_text(json.dumps(report,indent=2),'utf-8')
print(json.dumps(report))
