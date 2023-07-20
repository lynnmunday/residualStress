#!/opt/moose/miniconda/bin/python
import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
#-------------------------------------------------------------------------------
base_dir='/Users/mundlb/projects/isopod_inputs/residualStress/twoTemperatures/'
# df_invCut = pd.read_csv(base_dir+'optimization/parsedBC/invForwardLoad/bilayerInv_out_sigxx_ln_0_0001.csv')
df_noCut = pd.read_csv(base_dir+'syntheticData_fine/cut_0.0e-3_outputs/results_sigxx_ln_0_0001.csv')
print('\nColumn Names: \n',df_noCut.columns.values)

df_noise0 = pd.read_csv('cut_0.90e-3_noise0/forward_sigxx_ln_0_0001.csv')
df_noise1 = pd.read_csv('cut_0.90e-3_noise1/forward_sigxx_ln_0_0001.csv')
df_noise5 = pd.read_csv('cut_0.90e-3_noise5/forward_sigxx_ln_0_0001.csv')
df_noise10 = pd.read_csv('cut_0.90e-3_noise10/forward_sigxx_ln_0_0001.csv')
df_bias_noise0 = pd.read_csv('cut_0.90e-3_bias_noise0/forward_sigxx_ln_0_0001.csv')
df_bias_noise1 = pd.read_csv('cut_0.90e-3_bias_noise1/forward_sigxx_ln_0_0001.csv')
df_bias_noise5 = pd.read_csv('cut_0.90e-3_bias_noise5/forward_sigxx_ln_0_0001.csv')
df_bias_noise10 = pd.read_csv('cut_0.90e-3_bias_noise10/forward_sigxx_ln_0_0001.csv')
df = pd.read_csv('cut_0.90e-3_outputs/forward_sigxx_ln_0_0001.csv')
# df_noCut['inv_stress_xx']=df_noCut['inv_stress_xx']+df['stress_xx']

#-------------------------------------------------------------------------------
df_reg = pd.read_csv('cut_0.90e-3_noise0/forward_params_cutFace_0001.csv')
df_bias = pd.read_csv('cut_0.90e-3_bias_noise0/forward_params_cutFace_0001.csv')
reg_y_coords =np.array([1.0000E-04, 1.9000E-04, 2.8000E-04, 3.7000E-04, 4.6000E-04, 5.5000E-04, \
  6.4000E-04, 7.3000E-04, 8.2000E-04, 9.1000E-04, 1.0000E-03])
bias_y_coords =np.array([1.0000E-04, 2.8700E-04, 4.1790E-04, 5.0953E-04, 5.7367E-04, \
           6.1857E-04, 6.5000E-04,7.0657E-04, 7.8011E-04, 8.7572E-04, 1.0000E-03])
fig=plt.figure()
plt.plot(reg_y_coords*1e3,df_reg['source']/1e6,'--',\
             linewidth=1,marker='o',markersize=4,label='reg')
plt.plot(bias_y_coords*1e3,df_bias['source']/1e6,'--',\
             linewidth=1,marker='o',markersize=4,label='bias')
plt.ylabel("Optimized Force")
plt.xlabel("y_coord (mm)")
plt.grid()
plt.legend(loc='best', ncol=1)
plt.tight_layout()

fig=plt.figure()
plt.plot(df_noCut['y']*1e3,df_noCut['stress_xx']/1e6,'-',\
             linewidth=2,marker='*',label='Synthetic Data')
plt.plot(df['y']*1e3,-df['stress_xx']/1e6,'--',\
             linewidth=2,marker='o',label='Inverted')
plt.ylabel("stress xx (MPa)")
plt.xlabel("y_coord (mm)")
plt.legend(loc='best', ncol=1)
plt.tight_layout()


fig=plt.figure()
for xc in reg_y_coords:
    plt.axvline(x=xc*1e3,color='k',alpha=0.3)
plt.plot(df_noise0['y']*1e3,-df_noise0['stress_xx']/1e6,'--',\
             linewidth=1,marker='o',markersize=4,label='noise=0')
plt.plot(df_noise5['y']*1e3,-df_noise5['stress_xx']/1e6,'--',\
             linewidth=1,marker='*',markersize=4,label='noise=5')
plt.plot(df_noise10['y']*1e3,-df_noise10['stress_xx']/1e6,'--',\
             linewidth=1,marker='*',markersize=4,label='noise=10')
plt.plot(df_noCut['y']*1e3,df_noCut['stress_xx']/1e6,'--',\
             linewidth=1,color='k',label='Synthetic Data')
plt.ylabel("stress xx (MPa)")
plt.xlabel("y_coord (mm)")
plt.legend(loc='best', ncol=1)
plt.tight_layout()

fig=plt.figure()
for xc in bias_y_coords:
    plt.axvline(x=xc*1e3,color='k',alpha=0.3)
plt.plot(df_bias_noise0['y']*1e3,-df_bias_noise0['stress_xx']/1e6,'--',\
             linewidth=1,marker='o',markersize=4,label='noise=0')
plt.plot(df_bias_noise5['y']*1e3,-df_bias_noise5['stress_xx']/1e6,'--',\
             linewidth=1,marker='*',markersize=4,label='noise=5')
plt.plot(df_bias_noise10['y']*1e3,-df_bias_noise10['stress_xx']/1e6,'--',\
             linewidth=1,marker='*',markersize=4,label='noise=10')
plt.plot(df_noCut['y']*1e3,df_noCut['stress_xx']/1e6,'--',\
             linewidth=1,color='k',label='Synthetic Data')
plt.ylabel("stress xx (MPa)")
plt.xlabel("y_coord (mm)")
plt.legend(loc='best', ncol=1)
plt.tight_layout()


plt.show()


