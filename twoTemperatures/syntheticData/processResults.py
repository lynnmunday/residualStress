#!/opt/moose/miniconda/bin/python
import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
#-------------------------------------------------------------------------------
cut_depth=np.arange(0.05,1.0,0.05)
df_noCut = pd.read_csv('cut_0.0e-3_outputs/results_Nodes_0001.csv')
print('\nColumn Names: \n',df_noCut.columns.values)

df_old = df_noCut
for cut in cut_depth:
    df_output = pd.DataFrame()
    df_filter_output = pd.DataFrame()
    results_dir='cut_{:.2f}e-3_outputs/'.format(cut)
    #post-process measurement data with weights
    name=results_dir+'results_Nodes_0001.csv'

    df = pd.read_csv(name)
    df['weight_disp_x'] = 0
    df['weight_disp_y'] = 1e12
    df['diff_disp_x'] = 0
    df['diff_disp_y']=df['disp_y']-df_old['disp_y']
    df['weighted_diff_disp']=df['diff_disp_y']*df['weight_disp_y']
    noise_percentage_05 = 0.05
    noise_percentage_02 = 0.02
    n = np.random.normal(0, df['weighted_diff_disp'].std(), df.shape[0]) * noise_percentage_02
    df['weighted_diff_disp_2noise']=df['weighted_diff_disp']+n
    n = np.random.normal(0, df['weighted_diff_disp'].std(), df.shape[0]) * noise_percentage_05
    df['weighted_diff_disp_5noise']=df['weighted_diff_disp']+n
    df_output=pd.concat([df_output,df],ignore_index=True)
    name_yOut='cut_{:.2f}e-3_outputs/results_diff_y.csv'.format(cut)
    df.to_csv(name_yOut,index=False)

    disp_max=df['diff_disp_y'].abs().max()
    df_filtered = df[df['diff_disp_y'].abs() >= df['diff_disp_y'].abs().max()*.1];
    df_filter_output=pd.concat([df_filter_output,df_filtered],ignore_index=True)
    name_yOut='cut_{:.2f}e-3_outputs/resultsFilter_diff_y.csv'.format(cut)
    df_filtered.to_csv(name_yOut,index=False)

    df = pd.read_csv(name)
    df['weight_disp_x'] = 1e9
    df['weight_disp_y'] = 0
    df['diff_disp_x']=df['disp_x']-df_old['disp_x']
    df['diff_disp_y']=0
    df['weighted_diff_disp']=df['diff_disp_x']*df['weight_disp_x']
    n = np.random.normal(0, df['weighted_diff_disp'].std(), df.shape[0]) * noise_percentage_02
    df['weighted_diff_disp_2noise']=df['weighted_diff_disp']+n
    n = np.random.normal(0, df['weighted_diff_disp'].std(), df.shape[0]) * noise_percentage_05
    df['weighted_diff_disp_5noise']=df['weighted_diff_disp']+n
    df_output=pd.concat([df_output,df],ignore_index=True)
    name_xOut='cut_{:.2f}e-3_outputs/results_diff_x.csv'.format(cut)
    df.to_csv(name_xOut,index=False)

    disp_max=df['diff_disp_x'].abs().max()
    df_filtered = df[df['diff_disp_x'].abs() >= df['diff_disp_x'].abs().max()*.1];
    df_filter_output=pd.concat([df_filter_output,df_filtered],ignore_index=True)
    name_yOut='cut_{:.2f}e-3_outputs/resultsFilter_diff_x.csv'.format(cut)
    df_filtered.to_csv(name_yOut,index=False)


    name_AllOut='cut_{:.2f}e-3_outputs/results_diff.csv'.format(cut)
    df_output.to_csv(name_AllOut,index=False)
    name_FilterAllOut='cut_{:.2f}e-3_outputs/resultsFilter_diff.csv'.format(cut)
    df_filter_output.to_csv(name_FilterAllOut,index=False)
    df_old=df.copy(deep=True)
#-------------------------------------------------------------------------------
name='cut_{:.2f}e-3_outputs/results_diff.csv'.format(cut_depth[0])
print('\n\nResults file:',name)
df = pd.read_csv(name)
name='cut_{:.2f}e-3_outputs/resultsFilter_diff.csv'.format(cut_depth[0])
df_filter = pd.read_csv(name)
print('Column Names: \n',df.columns.values)
print('df_max_x= ',df['diff_disp_x'].abs().max(), '   df_max_y= ',df['diff_disp_y'].abs().max())
print('df # rows= ',df.shape[0], '  df_filter # rows= ',df_filter.shape[0])

name='cut_{:.2f}e-3_outputs/results_diff_x.csv'.format(cut_depth[0])
df = pd.read_csv(name)
name='cut_{:.2f}e-3_outputs/resultsFilter_diff_x.csv'.format(cut_depth[0])
df_filter = pd.read_csv(name)
print('diff_x max: df= ',df['diff_disp_x'].abs().max(),';   df_filter= ',df_filter['diff_disp_x'].abs().max())
print('diff_x min: df= ',df['diff_disp_x'].abs().min(),';   df_filter= ',df_filter['diff_disp_x'].abs().min())
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
#-------------------------------------------------------------------------------
# This is a single cut because df_old is not updated
df_old = df_noCut
cut_depth=np.arange(0.9,1.0,0.05)
for cut in cut_depth:
    df_output = pd.DataFrame()
    df_filter_output = pd.DataFrame()
    results_dir='cut_{:.2f}e-3_outputs/'.format(cut)
    #post-process measurement data with weights
    name=results_dir+'results_Nodes_0001.csv'

    df = pd.read_csv(name)
    df['weight_disp_x'] = 0
    df['weight_disp_y'] = 1e9
    df['diff_disp_x'] = 0
    df['diff_disp_y']=df['disp_y']-df_old['disp_y']
    df['weighted_diff_disp']=df['diff_disp_y']*df['weight_disp_y']
    noise_percentage_05 = 0.05
    noise_percentage_02 = 0.02
    noise_percentage_25 = 0.25
    n = np.random.normal(0, df['weighted_diff_disp'].std(), df.shape[0]) * noise_percentage_02
    df['weighted_diff_disp_2noise']=df['weighted_diff_disp']+n
    n = np.random.normal(0, df['weighted_diff_disp'].std(), df.shape[0]) * noise_percentage_05
    df['weighted_diff_disp_5noise']=df['weighted_diff_disp']+n
    n = np.random.normal(0, df['weighted_diff_disp'].std(), df.shape[0]) * noise_percentage_25
    df['weighted_diff_disp_25noise']=df['weighted_diff_disp']+n
    df_output=pd.concat([df_output,df],ignore_index=True)
    name_yOut='cut_{:.2f}e-3_outputs/singleCutResults_diff_y.csv'.format(cut)
    df.to_csv(name_yOut,index=False)

    disp_max=df['diff_disp_y'].abs().max()
    df_filtered = df[df['diff_disp_y'].abs() >= df['diff_disp_y'].abs().max()*.5];
    df_filter_output=pd.concat([df_filter_output,df_filtered],ignore_index=True)
    name_yOut='cut_{:.2f}e-3_outputs/singleCutResultsFilter_diff_y.csv'.format(cut)
    df_filtered.to_csv(name_yOut,index=False)

    df = pd.read_csv(name)
    df['weight_disp_x'] = 1e9
    df['weight_disp_y'] = 0
    df['diff_disp_x']=df['disp_x']-df_old['disp_x']
    df['diff_disp_y']=0
    df['weighted_diff_disp']=df['diff_disp_x']*df['weight_disp_x']
    n = np.random.normal(0, df['weighted_diff_disp'].std(), df.shape[0]) * noise_percentage_02
    df['weighted_diff_disp_2noise']=df['weighted_diff_disp']+n
    n = np.random.normal(0, df['weighted_diff_disp'].std(), df.shape[0]) * noise_percentage_05
    df['weighted_diff_disp_5noise']=df['weighted_diff_disp']+n
    n = np.random.normal(0, df['weighted_diff_disp'].std(), df.shape[0]) * noise_percentage_25
    df['weighted_diff_disp_25noise']=df['weighted_diff_disp']+n
    df_output=pd.concat([df_output,df],ignore_index=True)
    name_xOut='cut_{:.2f}e-3_outputs/singleCutResults_diff_x.csv'.format(cut)
    df.to_csv(name_xOut,index=False)

    disp_max=df['diff_disp_x'].abs().max()
    df_filtered = df[df['diff_disp_x'].abs() >= df['diff_disp_x'].abs().max()*.5];
    df_filter_output=pd.concat([df_filter_output,df_filtered],ignore_index=True)
    name_yOut='cut_{:.2f}e-3_outputs/singleCutResultsFilter_diff_x.csv'.format(cut)
    df_filtered.to_csv(name_yOut,index=False)


    name_AllOut='cut_{:.2f}e-3_outputs/singleCutResults_diff.csv'.format(cut)
    df_output.to_csv(name_AllOut,index=False)
    name_FilterAllOut='cut_{:.2f}e-3_outputs/singleCutResultsFilter_diff.csv'.format(cut)
    df_filter_output.to_csv(name_FilterAllOut,index=False)


#------------------------------------------------
name='cut_0.90e-3_outputs/singleCutResults_diff.csv'
print('\n\nResults file:',name)
df = pd.read_csv(name)
name='cut_0.90e-3_outputs/singleCutResultsFilter_diff.csv'
df_filter = pd.read_csv(name)
print('Column Names: \n',df.columns.values)
print('df_max_x= ',df['diff_disp_x'].abs().max(), '   df_max_y= ',df['diff_disp_y'].abs().max())
print('df # rows= ',df.shape[0], '  df_filter # rows= ',df_filter.shape[0])

name='cut_0.90e-3_outputs/singleCutResults_diff_x.csv'
df = pd.read_csv(name)
name='cut_0.90e-3_outputs/singleCutResultsFilter_diff_x.csv'
df_filter = pd.read_csv(name)
print('diff_x max: df= ',df['diff_disp_x'].abs().max(),';   df_filter= ',df_filter['diff_disp_x'].abs().max())
print('diff_x min: df= ',df['diff_disp_x'].abs().min(),';   df_filter= ',df_filter['diff_disp_x'].abs().min())
