#--------------------------------------------------------------------------#
#     layered plate mesh

# Width=25.4mm x Length=101.6mm x thickness=1.24mm -- 3.18mm Al-Al crimp around ouside
# everything is multiples of the height
unitLength = 1.3e-3 #height
cutIncrement = 0.1e-3
totalCut = 1.2e-3

height = ${unitLength}
lengthMultiple = 4
length = '${fparse lengthMultiple*unitLength}'

yelems = 40
xelems = '${fparse int(length/height)*yelems}'

[Mesh]
  [gen]
    type = GeneratedMeshGenerator
    dim = 2
    nx = ${xelems}
    ny = ${yelems}
    xmin = 0.0
    xmax = ${length}
    ymin = 0.0
    ymax = ${height}
    elem_type = QUAD4
  []
  #######------CUT-------#######
  [cutFaceRight]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'x>-1e-6 & x<1e-6 & y>${fparse height-totalCut} & y<${fparse height-totalCut+cutIncrement}'
    normal = '-1 0 0'
    new_sideset_name = cutFaceRight
    input = gen
  []
  [uncut]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'x>-1e-6 & x<1e-6  & y>-1e-6 & y<${fparse height-totalCut}'
    normal = '-1 0 0'
    new_sideset_name = uncut
    input = cutFaceRight
  []
[]
#--------------------------------------------------------------------------#

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Modules/TensorMechanics/Master]
  [all]
    strain = SMALL
    generate_output = 'stress_xx stress_yy stress_xy'
    use_automatic_differentiation = true
    add_variables = true
  []
[]

[Variables]
  [disp_x]
  []
  [disp_y]
  []
[]

[BCs]
  [left_x]
    type = ADDirichletBC
    boundary = uncut
    variable = disp_x
    value = 0.0
  []
  [right_x]
    type = ADDirichletBC
    boundary = right
    variable = disp_x
    value = 0.0
  []
  [right_y]
    type = ADDirichletBC
    boundary = right
    variable = disp_y
    value = 0.0
  []
[]

[Materials]
  [outsideElasticMatl_Al]
    type = ADComputeIsotropicElasticityTensor
    youngs_modulus = 69e9
    poissons_ratio = 0.33
  []
  [stress]
    type = ADComputeLinearElasticStress
  []
[]

[Executioner]
  type = Steady

  solve_type = 'NEWTON'
  petsc_options_iname = '-ksp_type -pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'preonly    lu       superlu_dist'

  line_search = 'none'

  l_max_its = 100
  l_tol = 1e-2

  nl_max_its = 15
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-9
[]

[Outputs]
  file_base = 'cut_${totalCut}_outputs/adjoint'
  csv = false
  exodus = true
[]

##---------Optimization stuff------------------#

[DiracKernels]
  [adjointLoad_y]
    type = ReporterPointSource
    variable = disp_y
    x_coord_name = misfit/measurement_xcoord
    y_coord_name = misfit/measurement_ycoord
    z_coord_name = misfit/measurement_zcoord
    value_name = misfit/misfit_values
    weight_name = misfit/weight_disp_y
  []
[]

[Reporters]
  [misfit]
    type = OptimizationData
    variable_weight_names = 'weight_disp_y'
  []
  [params_cutFace]
    type = ConstantReporter
    real_vector_names = 'cutFaceForce'
    real_vector_values = '0' # Dummy
  []
[]

[Functions]
  [cutFaceRight_function]
    type = ParsedOptimizationFunction
    expression = 'a'
    param_symbol_names = 'a'
    param_vector_name = 'params_cutFace/cutFaceForce'
  []
[]

[VectorPostprocessors]
  [grad_bc_cutFace]
    type = SideOptimizationNeumannFunctionInnerProduct
    variable = disp_x
    function = cutFaceRight_function
    boundary = cutFaceRight
  []
[]
