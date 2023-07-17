#!/opt/moose/miniconda/bin/python
import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
#-------------------------------------------------------------------------------

cut_depth=np.arange(0.1,1.3,0.1)
df_noCut = pd.read_csv('cut_0.0e-3_outputs/results_Nodes_0001.csv')
print('\nColumn Names: \n',df_noCut.columns.values)

df_old = df_noCut
for cut in cut_depth:
    df_output = pd.DataFrame()
    results_dir='cut_{:.2f}e-3_outputs/'.format(cut)
    #post-process measurement data with weights
    name=results_dir+'results_Nodes_0001.csv'

    df = pd.read_csv(name)
    df['weight_disp_x'] = 0
    df['weight_disp_y'] = 1e7
    df['diff_disp_x'] = 0
    df['diff_disp_y']=df['disp_y']-df_old['disp_y']
    df['weighted_diff_disp']=df['diff_disp_y']*df['weight_disp_y']
    df_output=pd.concat([df_output,df],ignore_index=True)

    name_yOut='cut_{:.2f}e-3_outputs/results_diff_y.csv'.format(cut)
    df_output.to_csv(name_yOut,index=False)

    df = pd.read_csv(name)
    df['weight_disp_x'] = 1e7
    df['weight_disp_y'] = 0
    df['diff_disp_x']=df['disp_x']-df_old['disp_x']
    df['diff_disp_y']=0
    df['weighted_diff_disp']=df['diff_disp_x']*df['weight_disp_x']
    df_output=pd.concat([df_output,df],ignore_index=True)

    name_AllOut='cut_{:.2f}e-3_outputs/results_diff.csv'.format(cut)
    df_output.to_csv(name_AllOut,index=False)
    df_old=df.copy(deep=True)

#-------------------------------------------------------------------------------
name='cut_{:.2f}e-3_outputs/results_diff.csv'.format(cut_depth[0])
print('\n\nResults file:',name)
df = pd.read_csv(name)
print('Column Names: \n',df.columns.values)
print(df)
# fig=plt.figure()
# for cut in cut_depth:
#     name='cut_{:.2f}e-3_outputs/results_diff.csv'.format(cut)
#     print(name)
#     df = pd.read_csv(name)
#     plt.plot(df['id']*1e3,df['disp_x_shifted'],'-'\
#              ,linewidth=2,marker='*',label='{:.2f}e-3'.format(cut))
#     plt.ylabel("disp_x_shifted (m)")
#     plt.xlabel("distance from cut (mm)")
#     plt.grid()
#     plt.legend(loc='best', ncol=1)
#     plt.tight_layout()

# plt.show()
