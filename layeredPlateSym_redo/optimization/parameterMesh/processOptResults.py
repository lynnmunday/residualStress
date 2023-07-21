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
cut_depth=np.arange(0.1,1.3,0.1)
for cut in cut_depth:
  df= pd.read_csv('cut_{:.2f}'.format(cut)+'e-3_outputs/forward_sigxx_ln_0_0001.csv')
  df = df[df['y'] >= (1.3-cut)*1e-3];
  plt.plot(df['y']*1e3,-df['stress_xx']/1e6,'--',\
             linewidth=2,marker='o',label='{:.1f}mm'.format(1.3-cut))

plt.plot(df_noCut['y']*1e3,df_noCut['stress_xx']/1e6,'--',\
             linewidth=1,color='k',label='Synthetic Data')
plt.ylabel("stress xx (MPa)")
plt.xlabel("y_coord (mm)")
plt.legend(loc='best', ncol=1)
plt.tight_layout()





plt.show()


