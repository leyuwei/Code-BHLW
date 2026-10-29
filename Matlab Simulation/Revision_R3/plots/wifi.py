from pathlib import Path
import sys,json
import pandas as pd
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from scipy.stats import t
root=Path(__file__).resolve().parents[1];out=Path(sys.argv[1]);out.mkdir(parents=True,exist_ok=True)
c=pd.read_csv(root/'results/revision26/matlab/wifi_correlation.csv')
w=pd.read_csv(root/'results/revision25/matlab/wifi_sensitivity.csv')
assert len(c)==110 and c.groupby(['spatial','correlation']).size().eq(5).all()
def ci(x):return t.ppf(.975,4)*np.std(x,ddof=1)/np.sqrt(5)
selected=[]
cases=[('uniform',0,'Uniform, '+r'$\rho=0$'),('clustered',0,'Clustered, '+r'$\rho=0$'),('uniform',.7,'Uniform, '+r'$\rho=0.7$'),('clustered',.7,'Clustered, '+r'$\rho=0.7$')]
for spatial,rho,label in cases:
 a=c[(c.spatial==spatial)&np.isclose(c.correlation,rho)]
 selected.append(dict(label=label,mean_gbps=a.mean_gbps.mean(),mean_ci=ci(a.mean_gbps),p05_gbps=a.p05_gbps.mean(),p05_ci=ci(a.p05_gbps)))
for key,label in [('offset_ap','Offset AP at $[1,1,0]\\,\\mathrm{m}$'),('channels_6','$M=6$ channels'),('channels_24','$M=24$ channels'),('shadow_6_8','Shadowing $6/8\\,\\mathrm{dB}$'),('rician_0','$K=0$'),('rician_5','$K=5$')]:
 a=w[w.scenario==key];assert len(a)==5
 selected.append(dict(label=label,mean_gbps=a.mean_gbps.mean(),mean_ci=ci(a.mean_gbps),p05_gbps=a.p05_gbps.mean(),p05_ci=ci(a.p05_gbps)))
pd.DataFrame(selected).to_csv(out/'wifi_selected.csv',index=False)
plt.rcParams.update({'font.family':'serif','font.serif':['Times New Roman'],'font.size':9,'legend.fontsize':7.5,'axes.spines.top':True,'axes.spines.right':True,'axes.grid':True,'grid.alpha':.3,'grid.linewidth':.6,'axes.linewidth':.8,'pdf.fonttype':42,'svg.fonttype':'none'})
fig,axes=plt.subplots(1,2,figsize=(6.3,3.0));fig.subplots_adjust(left=.19,right=.985,bottom=.26,top=.83,wspace=.4)
for j,(metric,label,color,hatch)in enumerate([('mean_gbps','Mean','#1965B0',''),('p05_gbps','5th percentile','#DC7B21','//')]):
 values=[z[metric]for z in selected[:4]];err=[z['mean_ci'if metric=='mean_gbps'else'p05_ci']for z in selected[:4]]
 axes[0].barh(np.arange(4)+(j-.5)*.34,values,height=.32,xerr=err,label=label,color=color,hatch=hatch,edgecolor='#333333',linewidth=.4)
axes[0].set_yticks(range(4),[z['label']for z in selected[:4]]);axes[0].invert_yaxis();axes[0].set_xlim(0,12);axes[0].set_xlabel('Aggregate rate (Gbit/s)');axes[0].legend(loc='upper center',bbox_to_anchor=(.5,1.22),ncol=2,frameon=False,handlelength=1.4)
for spatial,color in [('uniform','#1965B0'),('clustered','#DC7B21')]:
 for metric,style,marker,title in [('mean_gbps','-','o','mean'),('p05_gbps','--','s','5th pct.')]:
  a=c[c.spatial==spatial].groupby('correlation')[metric]
  axes[1].errorbar(a.mean().index,a.mean(),yerr=a.apply(ci),color=color,linestyle=style,marker=marker,markersize=3,capsize=1.5,label=spatial.capitalize()+', '+title)
axes[1].set_xlabel(r'Shadowing correlation $\rho$');axes[1].set_ylabel('Aggregate rate (Gbit/s)');axes[1].set_ylim(9.4,10.95);axes[1].legend(loc='upper center',bbox_to_anchor=(.5,1.26),ncol=2,frameon=False,fontsize=7,handlelength=1.3,columnspacing=.6)
for ax,label in zip(axes,['(a) Spatial and joint conditions','(b) Correlation sweep']):
 ax.grid(True);[s.set_visible(True)for s in ax.spines.values()];ax.text(.5,-.32,label,ha='center',va='top',transform=ax.transAxes)
for ext in ['pdf','svg','png']:fig.savefig(out/('wifi.'+ext),bbox_inches='tight',pad_inches=.04,dpi=300)
(out/'provenance.json').write_text(json.dumps(dict(new_simulations=0,correlation_runs_reused=110,samples_per_seed=100000,seeds=5,spatial_cases=['uniform','clipped Gaussian cluster'],shadow_model='sigma(d_i)*(sqrt(rho)*Z0+sqrt(1-rho)*Zi)',grid=True,box=True,subcaptions_below_centered=True),indent=2))
print(pd.DataFrame(selected).round(4).to_string(index=False))
