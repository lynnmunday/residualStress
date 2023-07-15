#!/opt/moose/miniconda/bin/python

import pandas as pd
import os
import sys
import numpy as np
import matplotlib.pyplot as plt
import math
import glob, os
# import matplotlib as mpl
import numpy as np
from scipy import stats
import re
#-------------------------------------------------------------------------------

SMALL_SIZE = 8
MEDIUM_SIZE = 10
BIGGER_SIZE = 12

plt.rc('font', size=MEDIUM_SIZE)          # controls default text sizes
plt.rc('axes', titlesize=MEDIUM_SIZE)     # fontsize of the axes title
plt.rc('axes', labelsize=MEDIUM_SIZE)    # fontsize of the x and y labels
plt.rc('xtick', labelsize=MEDIUM_SIZE)    # fontsize of the tick labels
plt.rc('ytick', labelsize=MEDIUM_SIZE)    # fontsize of the tick labels
plt.rc('legend', fontsize=SMALL_SIZE)    # legend fontsize
plt.rc('figure', titlesize=MEDIUM_SIZE)  # fontsize of the figure title

# Just for printing whats in the data frame
# this is also the no cut simulation used as a reference
df_noCut = pd.read_csv('cut_0.0e-3_outputs/results_dispy_ln_0_0001.csv')
print('\nColumn Names: \n',df_noCut.columns.values)

cut_depth=np.arange(0.1,1.2,0.1)
print(cut_depth)
line_style=['-','--',':']

################################################################################
fig=plt.figure()
df_old=df_noCut.copy(deep=True)
for cut in cut_depth:
    name='cut_{:.1f}e-3_outputs/results_dispy_ln_0_0001.csv'.format(cut)
    print(name)
    df = pd.read_csv(name)
    df['weight'] = 1e9
    df['diff_disp_y']=df['disp_y']-df_old['disp_y']
    df['weighted_diff_disp_y']=df['diff_disp_y']*df['weight']
    name_out='cut_{:.1f}e-3_outputs/results_diff.csv'.format(cut)
    df.to_csv(name_out,index=False)
    # plt.plot(df['x']*1e3,diff_disp*1e6,'-'\
    #          ,linewidth=2,marker='*',label='{:.1f}e-3'.format(cut))
    plt.plot(df['x']*1e3,(df['disp_y']-df_noCut['disp_y'])*1e6,'-'\
             ,linewidth=2,marker='*',label='{:.1f}e-3'.format(cut))
    plt.ylabel("disp(um)")
    plt.xlabel("distance from cut (mm)")
    plt.grid()
    plt.legend(loc='best', ncol=1)
    plt.tight_layout()
    df_old=df.copy(deep=True)




plt.show()
