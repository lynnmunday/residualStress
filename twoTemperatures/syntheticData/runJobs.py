#!/opt/moose/miniconda/bin/python
import os
import numpy as np
import pandas as pd
#-------------------------------------------------------------------------------
## Delete data produced by previous simulations
def remove_csv_data(dataDir):
    if os.path.exists(dataDir):
        name = os.listdir(dataDir)
        for i in name:
            path = dataDir+'/'+i
            if path.endswith(('.csv', '.e')):
                os.remove(path)
#-------------------------------------------------------------------------------

cut_depth=np.arange(0.05,1.0,0.05)
isopod_opt="/Users/mundlb/projects/isopod/isopod-opt"
input_file = "bilayer.i"
n_cores=2

#-------------------------------------------------------------------------------
noCutInputFile='bilayer_noCut.i'
baseDir = os.getcwd()
noCutDir = "cut_0.0e-3_outputs/"
if os.path.exists(noCutDir):
    remove_csv_data(noCutDir)
else:
    os.mkdir(noCutDir)
os.chdir(noCutDir)
cp_cmd='cp ../'+noCutInputFile+' .'
os.system(cp_cmd)
run_command = 'mpirun -np '+str(n_cores)+' '+isopod_opt+' '+ '-i'\
                  +' '+noCutInputFile
os.system(run_command)
os.chdir(baseDir)

#-------------------------------------------------------------------------------
df_old = pd.read_csv('cut_0.0e-3_outputs/results_dispy_ln_0_0001.csv')
for cut in cut_depth:
    results_dir='cut_{:.2f}e-3_outputs/'.format(cut)
    remove_csv_data(results_dir)
    cli_args="totalCut={:.2f}e-3".format(cut)
    print(cli_args)
    # run simulations
    run_command = 'mpirun -np '+str(n_cores)+' '+isopod_opt+' '+ '-i'\
                  +' '+input_file+' '+cli_args
    print(run_command)
    os.system(run_command)
