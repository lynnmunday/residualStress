totalCut = 0.20e-3

[Optimization]
[]

[OptimizationReporter]
  type = OptimizationReporter
  parameter_names = 'cutFaceForce'
  num_values = '1'
  measurement_file = 'resultsFilter_cut_0.20e-3.csv'
  # initial_condition = '50000'
  file_xcoord = 'x'
  file_ycoord = 'y'
  file_zcoord = 'z'
  file_value = 'weighted_diff_disp'
  file_variable_weights = 'weight_disp_x weight_disp_y'
[]
[Executioner]
  type = Optimize
  verbose = true
  ##--Hessian
  # tao_solver = taonls
  # petsc_options_iname = '-tao_gatol -tao_nls_pc_type -tao_nls_ksp_type'
  # petsc_options_value = '1e-6 none cg'
  ##--gradient
  # tao_solver = taobncg
  # petsc_options_iname = '-tao_gatol -tao_ls_type'
  # petsc_options_value = '1e-7 unit'
  ##--finite difference testing
  tao_solver = taobncg
  petsc_options_iname = '-tao_max_it -tao_fd_test -tao_test_gradient -tao_fd_gradient -tao_fd_delta'
  petsc_options_value = '1 true true false 1e-6'
  petsc_options = '-tao_test_gradient_view'
[]

[MultiApps]
  [forward]
    type = FullSolveMultiApp
    input_files = bilayer_forward.i
    execute_on = "FORWARD"
    cli_args = 'totalCut=${totalCut}'
  []
  [adjoint]
    type = FullSolveMultiApp
    input_files = bilayer_adjoint.i
    execute_on = "ADJOINT"
    cli_args = 'totalCut=${totalCut}'
  []
  [homogeneousForward]
    type = FullSolveMultiApp
    input_files = bilayer_homoForward.i
    execute_on = "HOMOGENEOUS_FORWARD"
    cli_args = 'totalCut=${totalCut}'
  []
[]

[Transfers]
  [toForward]
    type = MultiAppReporterTransfer
    to_multi_app = forward
    from_reporters = 'OptimizationReporter/measurement_xcoord
                      OptimizationReporter/measurement_ycoord
                      OptimizationReporter/measurement_zcoord
                      OptimizationReporter/measurement_time
                      OptimizationReporter/measurement_values
                      OptimizationReporter/weight_disp_x
                      OptimizationReporter/weight_disp_y
                      OptimizationReporter/cutFaceForce'
    to_reporters = 'measure_data/measurement_xcoord
                    measure_data/measurement_ycoord
                    measure_data/measurement_zcoord
                    measure_data/measurement_time
                    measure_data/measurement_values
                    measure_data/weight_disp_x
                    measure_data/weight_disp_y
                    params_cutFace/cutFaceForce'
  []
  [fromForward]
    type = MultiAppReporterTransfer
    from_multi_app = forward
    from_reporters = 'measure_data/simulation_values'
    to_reporters = 'OptimizationReporter/simulation_values'
  []
  [toAdjoint]
    type = MultiAppReporterTransfer
    to_multi_app = adjoint
    from_reporters = 'OptimizationReporter/measurement_xcoord
                      OptimizationReporter/measurement_ycoord
                      OptimizationReporter/measurement_zcoord
                      OptimizationReporter/measurement_time
                      OptimizationReporter/misfit_values
                      OptimizationReporter/weight_disp_x
                      OptimizationReporter/weight_disp_y
                      OptimizationReporter/cutFaceForce'
    to_reporters = 'misfit/measurement_xcoord
                    misfit/measurement_ycoord
                    misfit/measurement_zcoord
                    misfit/measurement_time
                    misfit/misfit_values
                    misfit/weight_disp_x
                    misfit/weight_disp_y
                    params_cutFace/cutFaceForce'
  []
  [fromadjoint]
    type = MultiAppReporterTransfer
    from_multi_app = adjoint
    from_reporters = 'grad_bc_cutFace/inner_product'
    to_reporters = 'OptimizationReporter/grad_cutFaceForce'
  []
  # HESSIAN transfers.  Same as forward.
  [toHomogeneousForward]
    type = MultiAppReporterTransfer
    to_multi_app = homogeneousForward
    from_reporters = 'OptimizationReporter/measurement_xcoord
                        OptimizationReporter/measurement_ycoord
                        OptimizationReporter/measurement_zcoord
                        OptimizationReporter/measurement_time
                        OptimizationReporter/measurement_values
                        OptimizationReporter/weight_disp_x
                        OptimizationReporter/weight_disp_y
                        OptimizationReporter/cutFaceForce'
    to_reporters = 'measure_data/measurement_xcoord
                      measure_data/measurement_ycoord
                      measure_data/measurement_zcoord
                      measure_data/measurement_time
                      measure_data/measurement_values
                      measure_data/weight_disp_x
                      measure_data/weight_disp_y
                      params_cutFace/cutFaceForce'
  []
  [fromHomogeneousForward]
    type = MultiAppReporterTransfer
    from_multi_app = homogeneousForward
    from_reporters = 'measure_data/simulation_values'
    to_reporters = 'OptimizationReporter/simulation_values'
  []
[]

[Reporters]
  [optInfo]
    type = OptimizationInfo
    items = 'current_iterate function_value gnorm'
  []
[]

[Outputs]
  file_base = cut_${totalCut}_outputs/results
  csv = true
  console = true
[]
