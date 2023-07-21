#!/opt/moose/miniconda/bin/python
import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
#-------------------------------------------------------------------------------
base_dir='/Users/mundlb/projects/isopod_inputs/residualStress/layeredPlateSym_redo/'
# df_invCut = pd.read_csv(base_dir+'optimization/parsedBC/invForwardLoad/bilayerInv_out_sigxx_ln_0_0001.csv')
df_noCut = pd.read_csv(base_dir+'syntheticData_fine/cut_0.0e-3_outputs/results_sigxx_ln_0_0001.csv')
print('\nColumn Names: \n',df_noCut.columns.values)



# df_noCut['inv_stress_xx']=df_noCut['inv_stress_xx']+df['stress_xx']

#-------------------------------------------------------------------------------

fig=plt.figure()
height=1.2
cut_depth=np.arange(0.1,1.2,0.1)
plt.axvspan(0.5,0.7, facecolor='r', alpha=0.2)
# plt.axvline(x=2,color='k', linestyle='--',linewidth=2)
for cut in cut_depth:
  df= pd.read_csv('cut_{:.2f}'.format(cut)+'e-3_outputs/forward_sigxx_ln_0_0001.csv')
  df = df[df['y'] >= (height-cut)*1e-3];
  plt.plot(df['y']*1e3,-df['stress_xx']/1e6,'--',\
             linewidth=1,marker='o',markersize='2',label='{:.1f}mm'.format(height-cut))

plt.plot(df_noCut['y']*1e3,df_noCut['stress_xx']/1e6,'--',\
             linewidth=1,color='k',label='Synthetic Data')
plt.ylabel("stress xx (MPa)")
plt.xlabel("y_coord (mm)")
plt.legend(loc='best', ncol=1)
plt.tight_layout()


reg_y_coords =np.array([1.0000E-04, 1.5000E-04, 2.0000E-04, 2.5000E-04, 3.0000E-04, \
3.5000E-04, 4.0000E-04, 4.5000E-04, 5.0000E-04, 5.5000E-04, \
6.0000E-04, 6.5000E-04, 7.0000E-04, 7.5000E-04, 8.0000E-04, \
8.5000E-04, 9.0000E-04, 9.5000E-04, 1.0000E-03, 1.0500E-03, \
1.1000E-03, 1.1500E-03, 1.2000E-03])

fig=plt.figure()
plt.axvspan(0.5,0.7, facecolor='r', alpha=0.2)
for xc in reg_y_coords:
    plt.axvline(x=xc*1e3,color='k',alpha=0.3)
df= pd.read_csv('cut_1.10e-3_outputs/forward_sigxx_ln_0_0001.csv')
df = df[df['y'] >= (height-cut)*1e-3];
plt.plot(df['y']*1e3,-df['stress_xx']/1e6,'--',\
             linewidth=2,marker='o',label='{:.1f}mm'.format(height-cut))

plt.plot(df_noCut['y']*1e3,df_noCut['stress_xx']/1e6,'--',\
             linewidth=1,color='k',label='Synthetic Data')
plt.ylabel("stress xx (MPa)")
plt.xlabel("y_coord (mm)")
plt.legend(loc='best', ncol=1)
plt.tight_layout()


plt.show()


