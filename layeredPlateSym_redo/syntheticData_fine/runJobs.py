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

cut_depth=np.arange(0.1,1.3,0.1)
isopod_opt="/Users/mundlb/projects/isopod/isopod-opt"
input_file = "layeredPlate.i"
n_cores=2

#-------------------------------------------------------------------------------
noCutInputFile='layeredPlate_noCut.i'
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
