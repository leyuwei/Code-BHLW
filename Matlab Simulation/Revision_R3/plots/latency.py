from pathlib import Path
import sys,json
import numpy as np
import pandas as pd
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from scipy.stats import t
data=Path(sys.argv[1]);old=Path(sys.argv[2]);out=Path(sys.argv[3]);out.mkdir(parents=True,exist_ok=True)
plt.rcParams.update({'font.family':'serif','font.serif':['Times New Roman'],'font.size':9,
 'axes.labelsize':9,'legend.fontsize':8,'axes.spines.top':True,'axes.spines.right':True,
 'axes.linewidth':.8,'axes.grid':True,'grid.alpha':.3,'grid.linewidth':.6,
 'lines.linewidth':1.3,'lines.markersize':4,'pdf.fonttype':42,'svg.fonttype':'none'})
colors=['#1965B0','#DC7B21','#4A8B46','#9356A0','#B43C39']
markers=['o','s','^','D','v'];styles=['-','--','-.',':',(0,(5,2))]
audit=[]
def interval(x):return t.ppf(.975,len(x)-1)*np.std(x,ddof=1)/np.sqrt(len(x))
def panel(ax,title,y=-.32):
 ax.grid(True);[sp.set_visible(True)for sp in ax.spines.values()]
 ax.text(.5,y,title,ha='center',va='top',transform=ax.transAxes,fontsize=9)
def save(fig,name):
 for ext in ['pdf','svg','png']:fig.savefig(out/(name+'.'+ext),bbox_inches='tight',dpi=300)
 for i,ax in enumerate(fig.axes):
  assert all(sp.get_visible()for sp in ax.spines.values())
  assert any(g.get_visible()for g in ax.get_xgridlines()+ax.get_ygridlines())
  labels=[z for z in ax.texts if z.get_text().startswith('(')];assert labels and all(z.get_position()[1]<0 and z.get_ha()=='center'for z in labels)
  audit.append(dict(figure=name,panel=i,grid=True,box=True,subcaption_below_centered=True))
 plt.close(fig)
def curves(ax,frame,x,col,groups,labels,xlabel,ylabel,log=False):
 for i,(val,label)in enumerate(zip(groups,labels)):
  z=frame[frame['group']==val].groupby(x)[col]
  ax.errorbar(z.mean().index,z.mean(),yerr=z.apply(interval),label=label,color=colors[i],marker=markers[i],linestyle=styles[i],capsize=2)
 ax.set_xlabel(xlabel);ax.set_ylabel(ylabel)
 if log:ax.set_xscale('log')

w=pd.read_csv(old/'wifi_sensitivity.csv');c=pd.read_csv(data/'matlab/wifi_correlation.csv')
fig,axes=plt.subplots(1,2,figsize=(6.15,3.1));fig.subplots_adjust(left=.16,right=.98,bottom=.27,top=.82,wspace=.48)
conditions=['nominal','clustered','offset_ap','channels_6','power_01','noise_7']
names=['Nominal','Clustered users','Offset AP','6 channels','0.1 W/channel','7 dB noise figure']
for j,(metric,label,color,hatch)in enumerate([('mean_gbps','Mean',colors[0],''),('p05_gbps','5th percentile',colors[1],'//')]):
 mean=[w[w.scenario==s][metric].mean()for s in conditions];err=[interval(w[w.scenario==s][metric])for s in conditions]
 axes[0].barh(np.arange(6)+(j-.5)*.34,mean,height=.32,xerr=err,label=label,color=color,hatch=hatch,edgecolor='#333333',linewidth=.4)
axes[0].set_yticks(range(6),names);axes[0].invert_yaxis();axes[0].set_xlim(0,12);axes[0].set_xlabel('Aggregate rate (Gbit/s)');axes[0].legend(loc='upper center',bbox_to_anchor=(.5,1.23),ncol=2,frameon=False)
panel(axes[0],'(a) Parameter sensitivity')
for spatial,color in [('uniform',colors[0]),('clustered',colors[1])]:
 for metric,style,marker,label in [('mean_gbps','-','o','mean'),('p05_gbps','--','s','5th pct.')]:
  z=c[c.spatial==spatial].groupby('correlation')[metric]
  axes[1].errorbar(z.mean().index,z.mean(),yerr=z.apply(interval),color=color,linestyle=style,marker=marker,capsize=1.5,label=f'{spatial.capitalize()}, {label}')
axes[1].set_xlabel(r'Shadowing correlation $\rho$');axes[1].set_ylabel('Aggregate rate (Gbit/s)');axes[1].set_ylim(9.4,10.95);axes[1].set_xticks(np.arange(0,1.01,.2));axes[1].legend(loc='upper center',bbox_to_anchor=(.5,1.25),ncol=2,fontsize=7.5,columnspacing=.8,handlelength=1.6,frameon=False)
panel(axes[1],'(b) Correlated channels');save(fig,'wifi')

h=pd.read_csv(data/'matlab/hybrid_runs.csv')
samples=np.loadtxt(data/'matlab/confirmation_samples.csv',delimiter=',');c=h[(h.experiment=='confirmations')&(h.traffic_probability==.01)]
fig,axes=plt.subplots(1,2,figsize=(6.15,3.0));fig.subplots_adjust(left=.1,right=.98,bottom=.26,top=.86,wspace=.37)
for i,conf in enumerate([1,2,4,8]):
 x=np.sort(samples[:,conf-1]);axes[0].plot(x,np.arange(1,len(x)+1)/len(x),color=colors[i],linestyle=styles[i],label=f'{conf} later block'+('s'if conf>1 else''))
axes[0].set_xlabel('Extra-confirmation waiting (s)');axes[0].set_ylabel('Cumulative probability');axes[0].set_xlim(0,200);axes[0].set_ylim(0,1);axes[0].legend(loc='lower right',fontsize=7,frameon=True);panel(axes[0],'(a) Confirmation-wait distribution')
m=c[c.confirmations.isin([0,1,2,4,8])].groupby('confirmations').mean(numeric_only=True);bottom=np.zeros(len(m))
for y,label,color,hatch in [(m.transport_mean_s+m.retrieval_mean_s,'Transport / retrieval','#9356A0',''),(m.inclusion_mean_s,'Inclusion',colors[0],''),(m.confirmation_mean_s,'Confirmations',colors[1],'//'),(m.queue_mean_s,'LD queue',colors[2],'xx'),(m.payload_mean_s,'Payload','#777777','..')]:
 axes[1].bar(range(len(m)),y,bottom=bottom,label=label,color=color,width=.72,hatch=hatch,edgecolor='#333333',linewidth=.35);bottom+=y.to_numpy()
assert np.allclose(bottom,m.completion_mean_s)
axes[1].set_xticks(range(len(m)),m.index.astype(int));axes[1].set_xlabel('Number of later blocks');axes[1].set_ylabel('Mean completion delay (s)');axes[1].legend(loc='upper left',fontsize=7,frameon=True);panel(axes[1],'(b) Full service path');save(fig,'latency')
(out/'figure_style_audit.json').write_text(json.dumps(audit,indent=2))
print('Exported the latency PDF/SVG/PNG figure; all panels passed grid/box/bottom-label checks.')
