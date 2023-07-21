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


df = pd.read_csv('cut_0.60e-3_outputs/forward_sigxx_ln_0_0001.csv')
# df_noCut['inv_stress_xx']=df_noCut['inv_stress_xx']+df['stress_xx']

#-------------------------------------------------------------------------------

fig=plt.figure()
plt.plot(df_noCut['y']*1e3,df_noCut['stress_xx']/1e6,'-',\
             linewidth=2,marker='*',label='Synthetic Data')
plt.plot(df['y']*1e3,-df['stress_xx']/1e6,'--',\
             linewidth=2,marker='o',label='Inverted')
plt.ylabel("stress xx (MPa)")
plt.xlabel("y_coord (mm)")
plt.legend(loc='best', ncol=1)
plt.tight_layout()





plt.show()


