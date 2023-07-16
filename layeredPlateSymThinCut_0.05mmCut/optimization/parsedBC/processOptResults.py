#!/opt/moose/miniconda/bin/python
import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
#-------------------------------------------------------------------------------

df_noCut = pd.read_csv('/Users/mundlb/projects/isopod_inputs/residualStress/layeredPlateSym/syntheticData/cut_0.0e-3_outputs/results_sigxx_ln_0_0001.csv')
print('\nColumn Names: \n',df_noCut.columns.values)

cut_depth=np.arange(0.1,1.3,0.05)
df_noCut['inv_stress_xx']=0
for cut in cut_depth:
    results_dir='cut_{:.2f}e-3_outputs/'.format(cut)
    #post-process measurement data with weights
    name=results_dir+'forward_sigxx_ln_0_0001.csv'
    df = pd.read_csv(name)
    df_noCut['inv_stress_xx']=df_noCut['inv_stress_xx']+df['stress_xx']

#-------------------------------------------------------------------------------
print('xy_data=')
force=[]
for cut in cut_depth:
    results_dir='cut_{:.2f}e-3_outputs/'.format(cut)
    #post-process measurement data with weights
    name=results_dir+'forward_params_cutFace_0001.csv'
    df = pd.read_csv(name)
    # print('cut= ',cut)
    # print('df= ',df['cutFaceForce'])
    force.append(-df['cutFaceForce'].iloc[-1])
    xy_data='{:.4f}'.format(cut*1e-3) + ' ' + str(-df['cutFaceForce'].iloc[-1])
    print(xy_data)

print("force=",force)
fig=plt.figure()
y_coord=np.flip(cut_depth)
plt.plot(y_coord,force,'-'\
             ,linewidth=2,marker='*',label='stress_xx')
plt.ylabel("Force (N)")
plt.xlabel("y_coord (mm)")
plt.grid()
plt.legend(loc='best', ncol=1)
plt.tight_layout()


#-------------------------------------------------------------------------------

fig=plt.figure()
plt.plot(df_noCut['y']*1e3,df_noCut['stress_xx'],'-'\
             ,linewidth=2,marker='*',label='stress_xx')
plt.plot(df_noCut['y']*1e3,-df_noCut['inv_stress_xx'],'--'\
             ,linewidth=2,marker='o',label='inv_stress_xx')
# plt.plot(df_invForce['y']*1e3,df_invForce['stress_xx'],'--'\
#              ,linewidth=1,marker='o',label='invForce_stress_xx')
plt.ylabel("stress (MPa)")
plt.xlabel("y_coord (mm)")
plt.grid()
plt.legend(loc='best', ncol=1)
plt.tight_layout()

plt.show()
