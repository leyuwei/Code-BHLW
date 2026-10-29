from pathlib import Path
import sys,json
import numpy as np
import pandas as pd
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from scipy.stats import t
root=Path(__file__).resolve().parents[1];data=root/'results/revision32/matlab';out=Path(sys.argv[1]);out.mkdir(parents=True,exist_ok=True)
plt.rcParams.update({'font.family':'serif','font.serif':['Times New Roman'],'font.size':9,
 'axes.labelsize':9,'legend.fontsize':7.5,'axes.spines.top':True,'axes.spines.right':True,
 'axes.linewidth':.8,'axes.grid':True,'grid.alpha':.3,'grid.linewidth':.6,
 'lines.linewidth':1.3,'lines.markersize':4,'pdf.fonttype':42,'svg.fonttype':'none'})
colors=['#1965B0','#DC7B21','#4A8B46','#9356A0','#B43C39'];markers=['o','s','^','D','v'];styles=['-','--','-.',':',(0,(5,2))]
audit=[]
def interval(x):return t.ppf(.975,len(x)-1)*np.std(x,ddof=1)/np.sqrt(len(x))
def panel(ax,text,y=-.275):
 ax.grid(True);[s.set_visible(True)for s in ax.spines.values()];ax.margins(x=.025)
 ax.text(.5,y,text,ha='center',va='top',transform=ax.transAxes,fontsize=9)
def save(fig,name):
 fig.canvas.draw()
 for i,ax in enumerate(fig.axes):
  assert all(s.get_visible()for s in ax.spines.values())
  assert any(x.get_visible()for x in ax.get_xgridlines()+ax.get_ygridlines())
  assert all(x.get_position()[1]<0 and x.get_ha()=='center'for x in ax.texts if x.get_text().startswith('('))
  audit.append(dict(figure=name,panel=i,grid=True,box=True,subcaption_below_centered=True,axes_bounds=list(ax.get_position().bounds)))
 for suffix in ['pdf','svg','png']:fig.savefig(out/(name+'.'+suffix),bbox_inches='tight',pad_inches=.04,dpi=300)
 plt.close(fig)
def curves(ax,frame,x,col,groups,labels,xlabel,ylabel,log=False):
 for i,(key,label)in enumerate(zip(groups,labels)):
  z=frame[frame['group']==key].groupby(x)[col]
  ax.errorbar(z.mean().index,z.mean(),yerr=z.apply(interval),label=label,color=colors[i],marker=markers[i],linestyle=styles[i],capsize=1.7)
 ax.set_xlabel(xlabel);ax.set_ylabel(ylabel)
 if log:ax.set_xscale('log')

fresh=pd.read_csv(data/'runs.csv');old=pd.read_csv(root/'results/revision26/matlab/hybrid_runs.csv');old=old[(old.experiment=='matched')&old['mode'].isin(['hybrid_no_ledger','hybrid_centralized','ledger_c0'])].copy();old['mode']=old['mode'].replace({'ledger_c0':'ledger'});old['outage_duty']=0.;old['request_frequency_s']=np.round(old.traffic_probability/.1,8);h=pd.concat([fresh[fresh.outage_duty==.8],old[old.outage_duty==0]],ignore_index=True);healthy=h[h.outage_duty==0].set_index(['seed','request_frequency_s','mode']).goodput_gbps
h['retained_rate']=np.array([row.goodput_gbps/healthy.loc[(row.seed,row.request_frequency_s,row['mode'])]for _,row in h.iterrows()])
fault=h[h.outage_duty==.8]
fig,axes=plt.subplots(2,2,figsize=(6.55,4.75));fig.subplots_adjust(left=.095,right=.99,bottom=.12,top=.925,hspace=.49,wspace=.27)
spec=[('hybrid_no_ledger','Hybrid-A','#1965B0','--','o',0),('hybrid_centralized','Hybrid-B','#4A8B46',':','s',1),('ledger',r'B-HLW ($c=0$)','#DC7B21','-','^',None)]
for ax,metric,ylabel,caption in zip(axes.flat,['goodput_gbps','retained_rate','access_p95_s','completion_p95_s'],['Completed-payload rate (Gbit/s)','Payload-rate retention','Access-delay 95th percentile (s)','Completion-delay 95th percentile (s)'],['(a) Service throughput','(b) Service retention','(c) Access delay','(d) Completion delay']):
 for mode,label,color,style,marker,offset in spec:
  frame=fault[fault['mode']==mode]
  z=frame.groupby('request_frequency_s')[metric];mean=z.mean();err=z.apply(interval)
  kw={}if offset is None else dict(markevery=(offset,2),errorevery=(offset,2))
  ax.errorbar(mean.index,mean,yerr=err,label=label,color=color,linestyle=style,marker=marker,capsize=1.7,zorder=4 if mode=='ledger'else 3,linewidth=1.3,**kw)
 ax.set_xscale('log');ax.set_xlabel(r'Request frequency per idle user ($\mathrm{s}^{-1}$)');ax.set_ylabel(ylabel);panel(ax,caption,y=-.32)
 if metric=='retained_rate':ax.set_ylim(0,max(1.08,h.retained_rate.max()+.03))
 else:ax.set_ylim(bottom=0)
legend=fig.legend(*axes[0,0].get_legend_handles_labels(),loc='upper center',bbox_to_anchor=(.5,1.005),ncol=3,fontsize=7.5,frameon=False,handlelength=1.4,columnspacing=.7,handletextpad=.4)
fig.canvas.draw();assert legend.get_window_extent().width<=fig.bbox.width
save(fig,'matched')
(out/'figure_style_audit.json').write_text(json.dumps(audit,indent=2))
(out/'provenance.json').write_text(json.dumps(dict(source='revision32/matlab/runs.csv; revision26/matlab/hybrid_runs.csv (zero-failure denominator)',new_simulations=255,unavailable_fraction=.8,schemes=['Hybrid-A','Hybrid-B','B-HLW'],acceptance_c=0,continuous_availability_results_retained_in_tables=True),indent=2))
print('Replotted the three schemes at the same unavailable fraction; source results unchanged.')
