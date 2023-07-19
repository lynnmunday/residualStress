#!/opt/moose/miniconda/bin/python
import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
#-------------------------------------------------------------------------------
base_dir='/Users/mundlb/projects/isopod_inputs/residualStress/twoTemperatures/'
# df_invCut = pd.read_csv(base_dir+'optimization/parsedBC/invForwardLoad/bilayerInv_out_sigxx_ln_0_0001.csv')
df_noCut = pd.read_csv(base_dir+'syntheticData/cut_0.0e-3_outputs/results_sigxx_ln_0_0001.csv')
print('\nColumn Names: \n',df_noCut.columns.values)

df_noise5 = pd.read_csv('cut_0.90e-3_noise5/forward_sigxx_ln_0_0001.csv')
df_noise2 = pd.read_csv('cut_0.90e-3_noise2/forward_sigxx_ln_0_0001.csv')
df_noise0 = pd.read_csv('cut_0.90e-3_noise0/forward_sigxx_ln_0_0001.csv')
# df_noCut['inv_stress_xx']=df_noCut['inv_stress_xx']+df['stress_xx']

#-------------------------------------------------------------------------------

fig=plt.figure()
plt.plot(df_noCut['y']*1e3,df_noCut['stress_xx'],'-'\
             ,linewidth=2,marker='*',label='Synthetic Data')
plt.plot(df_noCut['y']*1e3,-df_noise0['stress_xx'],'--'\
             ,linewidth=2,marker='o',label='noise=0')
plt.plot(df_noCut['y']*1e3,-df_noise2['stress_xx'],'--'\
             ,linewidth=2,marker='o',label='noise=2')
plt.plot(df_noCut['y']*1e3,-df_noise5['stress_xx'],'--'\
             ,linewidth=2,marker='o',label='noise=5')
# plt.plot(df_invCut['y']*1e3,df_invCut['stress_xx'],'--'\
#              ,linewidth=1,marker='o',label='invForce_stress_xx')
plt.ylabel("stress xx (MPa)")
plt.xlabel("y_coord (mm)")
plt.grid()
plt.legend(loc='best', ncol=1)
plt.tight_layout()

plt.show()
