totalCut = 0.90e-3

[Optimization]
[]

measurementDir = '/Users/mundlb/projects/isopod_inputs/residualStress/twoTemperatures/syntheticData'
[OptimizationReporter]
  type = OptimizationReporter
  parameter_names = 'cutFaceForce0 cutFaceForce1 cutFaceForce2 cutFaceForce3 cutFaceForce4 cutFaceForce5 cutFaceForce6 cutFaceForce7 cutFaceForce8 cutFaceForce9'
  num_values = '1 1 1 1 1 1 1 1 1 1'
  measurement_file = '${measurementDir}/cut_${totalCut}_outputs/singleCutResults_diff_x.csv'
  # initial_condition = '50000'
  file_xcoord = 'x'
  file_ycoord = 'y'
  file_zcoord = 'z'
  file_value = 'weighted_diff_disp'
  file_variable_weights = 'weight_disp_x'
[]
[Executioner]
  type = Optimize
  verbose = true
  ##--Hessian
  tao_solver = taonls
  petsc_options_iname = '-tao_grtol -tao_gatol -tao_nls_pc_type -tao_nls_ksp_type'
  petsc_options_value = '1e-16 1e-5 none cg'
  ##--gradient
  # tao_solver = taobncg
  # petsc_options_iname = '-tao_gatol -tao_ls_type'
  # petsc_options_value = '1e-7 unit'
  ##--finite difference testing
  # tao_solver = taobncg
  # petsc_options_iname = '-tao_max_it -tao_fd_test -tao_test_gradient -tao_fd_gradient -tao_fd_delta'
  # petsc_options_value = '1 true true false 1e2'
  # petsc_options = '-tao_test_gradient_view'
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
                      OptimizationReporter/cutFaceForce0
                      OptimizationReporter/cutFaceForce1
                      OptimizationReporter/cutFaceForce2
                      OptimizationReporter/cutFaceForce3
                      OptimizationReporter/cutFaceForce4
                      OptimizationReporter/cutFaceForce5
                      OptimizationReporter/cutFaceForce6
                      OptimizationReporter/cutFaceForce7
                      OptimizationReporter/cutFaceForce8
                      OptimizationReporter/cutFaceForce9'
    to_reporters = 'measure_data/measurement_xcoord
                    measure_data/measurement_ycoord
                    measure_data/measurement_zcoord
                    measure_data/measurement_time
                    measure_data/measurement_values
                    measure_data/weight_disp_x
                    params_cutFace/cutFaceForce0
                    params_cutFace/cutFaceForce1
                    params_cutFace/cutFaceForce2
                    params_cutFace/cutFaceForce3
                    params_cutFace/cutFaceForce4
                    params_cutFace/cutFaceForce5
                    params_cutFace/cutFaceForce6
                    params_cutFace/cutFaceForce7
                    params_cutFace/cutFaceForce8
                    params_cutFace/cutFaceForce9'
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
                      OptimizationReporter/cutFaceForce0
                      OptimizationReporter/cutFaceForce1
                      OptimizationReporter/cutFaceForce2
                      OptimizationReporter/cutFaceForce3
                      OptimizationReporter/cutFaceForce4
                      OptimizationReporter/cutFaceForce5
                      OptimizationReporter/cutFaceForce6
                      OptimizationReporter/cutFaceForce7
                      OptimizationReporter/cutFaceForce8
                      OptimizationReporter/cutFaceForce9'
    to_reporters = 'misfit/measurement_xcoord
                    misfit/measurement_ycoord
                    misfit/measurement_zcoord
                    misfit/measurement_time
                    misfit/misfit_values
                    misfit/weight_disp_x
                    params_cutFace/cutFaceForce0
                    params_cutFace/cutFaceForce1
                    params_cutFace/cutFaceForce2
                    params_cutFace/cutFaceForce3
                    params_cutFace/cutFaceForce4
                    params_cutFace/cutFaceForce5
                    params_cutFace/cutFaceForce6
                    params_cutFace/cutFaceForce7
                    params_cutFace/cutFaceForce8
                    params_cutFace/cutFaceForce9'
  []
  [fromadjoint]
    type = MultiAppReporterTransfer
    from_multi_app = adjoint
    from_reporters = 'grad_bc_cutFace0/inner_product
                      grad_bc_cutFace1/inner_product
                      grad_bc_cutFace2/inner_product
                      grad_bc_cutFace3/inner_product
                      grad_bc_cutFace4/inner_product
                      grad_bc_cutFace5/inner_product
                      grad_bc_cutFace6/inner_product
                      grad_bc_cutFace7/inner_product
                      grad_bc_cutFace8/inner_product
                      grad_bc_cutFace9/inner_product'
    to_reporters = 'OptimizationReporter/grad_cutFaceForce0
                    OptimizationReporter/grad_cutFaceForce1
                    OptimizationReporter/grad_cutFaceForce2
                    OptimizationReporter/grad_cutFaceForce3
                    OptimizationReporter/grad_cutFaceForce4
                    OptimizationReporter/grad_cutFaceForce5
                    OptimizationReporter/grad_cutFaceForce6
                    OptimizationReporter/grad_cutFaceForce7
                    OptimizationReporter/grad_cutFaceForce8
                    OptimizationReporter/grad_cutFaceForce9'
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
                        OptimizationReporter/cutFaceForce0
                        OptimizationReporter/cutFaceForce1
                        OptimizationReporter/cutFaceForce2
                        OptimizationReporter/cutFaceForce3
                        OptimizationReporter/cutFaceForce4
                        OptimizationReporter/cutFaceForce5
                        OptimizationReporter/cutFaceForce6
                        OptimizationReporter/cutFaceForce7
                        OptimizationReporter/cutFaceForce8
                        OptimizationReporter/cutFaceForce9'
    to_reporters = 'measure_data/measurement_xcoord
                      measure_data/measurement_ycoord
                      measure_data/measurement_zcoord
                      measure_data/measurement_time
                      measure_data/measurement_values
                      measure_data/weight_disp_x
                      params_cutFace/cutFaceForce0
                      params_cutFace/cutFaceForce1
                      params_cutFace/cutFaceForce2
                      params_cutFace/cutFaceForce3
                      params_cutFace/cutFaceForce4
                      params_cutFace/cutFaceForce5
                      params_cutFace/cutFaceForce6
                      params_cutFace/cutFaceForce7
                      params_cutFace/cutFaceForce8
                      params_cutFace/cutFaceForce9'
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
