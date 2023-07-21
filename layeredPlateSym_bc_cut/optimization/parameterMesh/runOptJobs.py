#!/opt/moose/miniconda/bin/python
import os
import numpy as np
import pandas as pd
#-------------------------------------------------------------------------------
## Delete data produced by previous simulations
def empty_and_remove_directory(dataDir):
    if os.path.exists(dataDir):
        filenames = os.listdir(dataDir)
        for filename in filenames:
            path = dataDir+'/'+filename
            os.remove(path)
        os.rmdir(dataDir)
#-------------------------------------------------------------------------------

cut_depth=np.arange(0.10,1.2,0.10)
isopod_opt="/Users/mundlb/projects/isopod/isopod-opt"
input_file = "bilayer_main.i"
mesh_input_file="parameter_mesh.i"
n_cores=2

#-------------------------------------------------------------------------------
for cut in cut_depth:
    results_dir='cut_{:.2f}e-3_outputs/'.format(cut)
    empty_and_remove_directory(results_dir)

    cli_args="totalCut={:.2f}e-3".format(cut)
    print(cli_args)
    # create parameter mesh
    run_command = isopod_opt+' '+ '-i'\
                  +' '+mesh_input_file+' '+cli_args+' --mesh-only'
    print(run_command)
    os.system(run_command)
    os.rename('parameter_mesh_in.e',"parameter_mesh_in_{:.2f}e-3.e".format(cut))
    # run simulations
    run_command = 'mpirun -np '+str(n_cores)+' '+isopod_opt+' '+ '-i'\
                  +' '+input_file+' '+cli_args
    print(run_command)
    os.system(run_command)

