#!/opt/moose/miniconda/bin/python
import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

#-------------------------------------------------------------------------------

cut_depth=np.arange(0.1,1.2,0.1)
weight=1e9

#-------------------------------------------------------------------------------
# THIS IS FOR ALL NODAL DATA X & Y
# This is a single cut because df_old is not updated
outputFile='results_Nodes_0001.csv'
df_noCut = pd.read_csv('cut_0.0e-3_outputs/'+outputFile)
print('\nColumn Names: \n',df_noCut.columns.values)
for cut in cut_depth:
    df_all_output = pd.DataFrame()
    df_filter_output = pd.DataFrame()
    results_dir='cut_{:.2f}e-3_outputs/'.format(cut)
    #post-process measurement data with weights
    name=results_dir+outputFile

    #----- Weighting y displacement
    df = pd.read_csv(name)
    df['weight_disp_x'] = 0
    df['weight_disp_y'] = weight
    df['diff_disp_x'] = 0
    df['diff_disp_y']=df['disp_y']-df_noCut['disp_y']
    df['weighted_diff_disp']=df['diff_disp_y']*df['weight_disp_y']
    noise_percentage_05 = 0.05
    noise_percentage_01 = 0.01
    noise_percentage_10 = 0.10
    #multiplication
    # noise_vec = (1+0.05*np.random.normal(0,1,);
    # measurement = simulation.*noise_vec;
    #additive
    n = df['weighted_diff_disp'].abs().max()*noise_percentage_01*np.random.normal(0,1, df.shape[0]);
    df['weighted_diff_disp_1noise']=df['weighted_diff_disp']+n
    n = df['weighted_diff_disp'].abs().max()*noise_percentage_05*np.random.normal(0,1, df.shape[0]);
    df['weighted_diff_disp_5noise']=df['weighted_diff_disp']+n
    n = df['weighted_diff_disp'].abs().max()*noise_percentage_10*np.random.normal(0,1, df.shape[0]);
    df['weighted_diff_disp_10noise']=df['weighted_diff_disp']+n

    name_yOut='cut_{:.2f}e-3_outputs/singleCutResults_diff_y.csv'.format(cut)
    df.to_csv(name_yOut,index=False)
    disp_max=df['diff_disp_y'].abs().max()
    df_filtered = df[df['diff_disp_y'].abs() >= df['diff_disp_y'].abs().max()*.5];
    # df_filtered = df[df['x'] <= 0.3e-3];
    name_yOut='cut_{:.2f}e-3_outputs/singleCutResultsFilter_diff_y.csv'.format(cut)
    df_filtered.to_csv(name_yOut,index=False)

    # THIS IS FOR CONCATING WEIGHTED X AND Y DISPLACEMENTS
    df_all_output=pd.concat([df_all_output,df],ignore_index=True)
    df_filter_output=pd.concat([df_filter_output,df_filtered],ignore_index=True)
    #----- Weighting x displacement
    df = pd.read_csv(name)
    df['weight_disp_x'] = weight
    df['weight_disp_y'] = 0
    df['diff_disp_x']=df['disp_x']-df_noCut['disp_x']
    df['diff_disp_y']=0
    df['weighted_diff_disp']=df['diff_disp_x']*df['weight_disp_x']

    n = df['weighted_diff_disp'].abs().max()*noise_percentage_01*np.random.normal(0,1, df.shape[0]);
    df['weighted_diff_disp_1noise']=df['weighted_diff_disp']+n
    n = df['weighted_diff_disp'].abs().max()*noise_percentage_05*np.random.normal(0,1, df.shape[0]);
    df['weighted_diff_disp_5noise']=df['weighted_diff_disp']+n
    n = df['weighted_diff_disp'].abs().max()*noise_percentage_10*np.random.normal(0,1, df.shape[0]);
    df['weighted_diff_disp_10noise']=df['weighted_diff_disp']+n

    name_xOut='cut_{:.2f}e-3_outputs/singleCutResults_diff_x.csv'.format(cut)
    df.to_csv(name_xOut,index=False)

    disp_max=df['diff_disp_x'].abs().max()
    df_filtered = df[df['diff_disp_x'].abs() >= df['diff_disp_x'].abs().max()*.5];
    # df_filtered = df[df['x'] <= 0.3e-3];
    name_yOut='cut_{:.2f}e-3_outputs/singleCutResultsFilter_diff_x.csv'.format(cut)
    df_filtered.to_csv(name_yOut,index=False)

    # THIS IS FOR CONCATING WEIGHTED X AND Y DISPLACEMENTS AND OUTPUTTING
    df_all_output=pd.concat([df_all_output,df],ignore_index=True)
    df_filter_output=pd.concat([df_filter_output,df_filtered],ignore_index=True)
    name_AllOut='cut_{:.2f}e-3_outputs/singleCutResults_diff.csv'.format(cut)
    df_all_output.to_csv(name_AllOut,index=False)
    name_FilterAllOut='cut_{:.2f}e-3_outputs/singleCutResultsFilter_diff.csv'.format(cut)
    df_filter_output.to_csv(name_FilterAllOut,index=False)

#-------------------------------------------------------------------------------
# THIS IS FOR TOP SURFACE Y-DISPLACEMENT
# This is a single cut because there is not a df_old
outputFile='results_dispy_top_0001.csv'
df_noCut = pd.read_csv('cut_0.0e-3_outputs/'+outputFile)
for cut in cut_depth:
    df_all_output = pd.DataFrame()
    df_filter_output = pd.DataFrame()
    results_dir='cut_{:.2f}e-3_outputs/'.format(cut)
    #post-process measurement data with weights
    name=results_dir+outputFile

    #----- Weighting y displacement
    df = pd.read_csv(name)
    df['weight_disp_y'] = weight
    df['diff_disp_y']=df['disp_y']-df_noCut['disp_y']
    df['weighted_diff_disp']=df['diff_disp_y']*df['weight_disp_y']
    noise_percentage_05 = 0.05
    noise_percentage_01 = 0.01
    noise_percentage_10 = 0.10

    n = df['weighted_diff_disp'].abs().max()*noise_percentage_01*np.random.normal(0,1, df.shape[0]);
    df['weighted_diff_disp_1noise']=df['weighted_diff_disp']+n
    n = df['weighted_diff_disp'].abs().max()*noise_percentage_05*np.random.normal(0,1, df.shape[0]);
    df['weighted_diff_disp_5noise']=df['weighted_diff_disp']+n
    n = df['weighted_diff_disp'].abs().max()*noise_percentage_10*np.random.normal(0,1, df.shape[0]);
    df['weighted_diff_disp_10noise']=df['weighted_diff_disp']+n

    name_yOut='cut_{:.2f}e-3_outputs/singleCutResults_top_diff_y.csv'.format(cut)
    df.to_csv(name_yOut,index=False)
    disp_max=df['diff_disp_y'].abs().max()
    df_filtered = df[df['diff_disp_y'].abs() >= df['diff_disp_y'].abs().max()*.5];
    name_yOut='cut_{:.2f}e-3_outputs/singleCutResultsFilter_top_diff_y.csv'.format(cut)
    df_filtered.to_csv(name_yOut,index=False)
    print('\n\nResults file:',name_yOut)
    print('df # rows= ',df.shape[0], '  df_filter # rows= ',df_filtered.shape[0])

#------------------------------------------------
cut_depth="0.90e-3"
name='cut_'+cut_depth+'_outputs/singleCutResults_top_diff_y.csv'
print('\n\nResults file:',name)
df = pd.read_csv(name)
name='cut_'+cut_depth+'_outputs/singleCutResultsFilter_top_diff_y.csv'
df_filter = pd.read_csv(name)
print('Column Names: \n',df.columns.values)
print('df_max_y= ',df['diff_disp_y'].abs().max())
print('df # rows= ',df.shape[0], '  df_filter # rows= ',df_filter.shape[0])

name='cut_'+cut_depth+'_outputs/singleCutResults_top_diff_y.csv'
df = pd.read_csv(name)
name='cut_'+cut_depth+'_outputs/singleCutResultsFilter_top_diff_y.csv'
df_filter = pd.read_csv(name)
print('diff_y max: df= ',df['diff_disp_y'].abs().max(),';   df_filter= ',df_filter['diff_disp_y'].abs().max())
print('diff_y min: df= ',df['diff_disp_y'].abs().min(),';   df_filter= ',df_filter['diff_disp_y'].abs().min())

fig=plt.figure()
plt.plot(df['x'],df['weighted_diff_disp_10noise'],'-',color='y',\
             linewidth=1,marker='*',label='noise=10')
plt.plot(df['x'],df['weighted_diff_disp_5noise'],'-',color='m',\
             linewidth=1,marker='*',label='noise=5')
plt.plot(df['x'],df['weighted_diff_disp_1noise'],'-',color='c',\
             linewidth=1,marker='*',markersize=4,label='noise=1')
plt.plot(df['x'],df['weighted_diff_disp'],'-',color='k',\
             linewidth=1,marker='*',markersize=2,label='noise=0')
plt.legend(loc='best', ncol=1)
plt.ylabel("weighted_diff_disp")
plt.xlabel("x_coord (m)")

fig=plt.figure()
plt.plot(df_filter['x'],df_filter['weighted_diff_disp_10noise'],'-',color='y',\
             linewidth=1,marker='*',label='noise=10')
plt.plot(df_filter['x'],df_filter['weighted_diff_disp_5noise'],'-',color='m',\
             linewidth=1,marker='*',label='noise=5')
plt.plot(df_filter['x'],df_filter['weighted_diff_disp_1noise'],'-',color='c',\
             linewidth=1,marker='*',markersize=4,label='noise=1')
plt.plot(df_filter['x'],df_filter['weighted_diff_disp'],'-',color='k',\
             linewidth=1,marker='*',markersize=2,label='noise=0')
plt.legend(loc='best', ncol=1)
plt.ylabel("weighted_diff_disp")
plt.xlabel("x_coord (m)")

plt.show()
