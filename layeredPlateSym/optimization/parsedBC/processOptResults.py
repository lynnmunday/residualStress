#!/opt/moose/miniconda/bin/python
import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
#-------------------------------------------------------------------------------

df_noCut = pd.read_csv('/Users/mundlb/projects/isopod_inputs/residualStress/layeredPlateSym/syntheticData/cut_0.0e-3_outputs/results_sigxx_ln_0_0001.csv')
print('\nColumn Names: \n',df_noCut.columns.values)

cut_depth=np.arange(0.1,1.3,0.1)
df_noCut['inv_stress_xx']=0
for cut in cut_depth:
    results_dir='cut_{:.1f}e-3_outputs/'.format(cut)
    #post-process measurement data with weights
    name=results_dir+'forward_sigxx_ln_0_0001.csv'
    df = pd.read_csv(name)
    df_noCut['inv_stress_xx']=df_noCut['inv_stress_xx']+df['stress_xx']

#-------------------------------------------------------------------------------

fig=plt.figure()
plt.plot(df_noCut['y']*1e3,df_noCut['stress_xx'],'-'\
             ,linewidth=2,marker='*',label='stress_xx')
plt.plot(df_noCut['y']*1e3,-df_noCut['inv_stress_xx'],'-'\
             ,linewidth=2,marker='*',label='inv_stress_xx')
plt.ylabel("stress (MPa)")
plt.xlabel("depth (mm)")
plt.grid()
plt.legend(loc='best', ncol=1)
plt.tight_layout()

plt.show()
