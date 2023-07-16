#!/opt/moose/miniconda/bin/python
import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
#-------------------------------------------------------------------------------

cut_depth=np.arange(0.2,1.2,0.2)
df_noCut = pd.read_csv('cut_0.0e-3_outputs/results_dispy_ln_0_0001.csv')
print('\nColumn Names: \n',df_noCut.columns.values)

df_old = df_noCut
for cut in cut_depth:
    results_dir='cut_{:.2f}e-3_outputs/'.format(cut)
    #post-process measurement data with weights
    name=results_dir+'results_dispy_ln_0_0001.csv'
    df = pd.read_csv(name)
    df['weight'] = 1e9
    df['diff_disp_y']=df['disp_y']-df_old['disp_y']
    df['weighted_diff_disp_y']=df['diff_disp_y']*df['weight']
    df['disp_y_shifted']=df['disp_y']-df_noCut['disp_y']
    name_out='cut_{:.2f}e-3_outputs/results_diff.csv'.format(cut)
    df.to_csv(name_out,index=False)
    df_old=df.copy(deep=True)

#-------------------------------------------------------------------------------

fig=plt.figure()
for cut in cut_depth:
    name='cut_{:.2f}e-3_outputs/results_diff.csv'.format(cut)
    print(name)
    df = pd.read_csv(name)
    plt.plot(df['x']*1e3,df['disp_y_shifted'],'-'\
             ,linewidth=2,marker='*',label='{:.2f}e-3'.format(cut))
    plt.ylabel("disp_y_shifted (m)")
    plt.xlabel("distance from cut (mm)")
    plt.grid()
    plt.legend(loc='best', ncol=1)
    plt.tight_layout()

plt.show()
