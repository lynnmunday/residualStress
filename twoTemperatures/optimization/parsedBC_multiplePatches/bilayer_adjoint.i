unitLength = 1.0e-3 #height
totalCut = 0.9e-3

height = ${unitLength}
lengthMultiple = 0.5
length = '${fparse lengthMultiple*unitLength}'

yelems = 20
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
  [cutFaceRight0]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'x>-1e-6 & x<1e-6 & y>${fparse height-totalCut+0*totalCut/10} & y<${fparse height-totalCut+1*totalCut/10}'
    normal = '-1 0 0'
    new_sideset_name = cutFaceRight0
    input = gen
  []
  [cutFaceRight1]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'x>-1e-6 & x<1e-6 & y>${fparse height-totalCut+1*totalCut/10} & y<${fparse height-totalCut+2*totalCut/10}'
    normal = '-1 0 0'
    new_sideset_name = cutFaceRight1
    input = cutFaceRight0
  []
  [cutFaceRight2]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'x>-1e-6 & x<1e-6 & y>${fparse height-totalCut+2*totalCut/10} & y<${fparse height-totalCut+3*totalCut/10}'
    normal = '-1 0 0'
    new_sideset_name = cutFaceRight2
    input = cutFaceRight1
  []
  [cutFaceRight3]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'x>-1e-6 & x<1e-6 & y>${fparse height-totalCut+3*totalCut/10} & y<${fparse height-totalCut+4*totalCut/10}'
    normal = '-1 0 0'
    new_sideset_name = cutFaceRight3
    input = cutFaceRight2
  []
  [cutFaceRight4]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'x>-1e-6 & x<1e-6 & y>${fparse height-totalCut+4*totalCut/10} & y<${fparse height-totalCut+5*totalCut/10}'
    normal = '-1 0 0'
    new_sideset_name = cutFaceRight4
    input = cutFaceRight3
  []
  [cutFaceRight5]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'x>-1e-6 & x<1e-6 & y>${fparse height-totalCut+5*totalCut/10} & y<${fparse height-totalCut+6*totalCut/10}'
    normal = '-1 0 0'
    new_sideset_name = cutFaceRight5
    input = cutFaceRight4
  []
  [cutFaceRight6]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'x>-1e-6 & x<1e-6 & y>${fparse height-totalCut+6*totalCut/10} & y<${fparse height-totalCut+7*totalCut/10}'
    normal = '-1 0 0'
    new_sideset_name = cutFaceRight6
    input = cutFaceRight5
  []
  [cutFaceRight7]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'x>-1e-6 & x<1e-6 & y>${fparse height-totalCut+7*totalCut/10} & y<${fparse height-totalCut+8*totalCut/10}'
    normal = '-1 0 0'
    new_sideset_name = cutFaceRight7
    input = cutFaceRight6
  []
  [cutFaceRight8]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'x>-1e-6 & x<1e-6 & y>${fparse height-totalCut+8*totalCut/10} & y<${fparse height-totalCut+9*totalCut/10}'
    normal = '-1 0 0'
    new_sideset_name = cutFaceRight8
    input = cutFaceRight7
  []
  [cutFaceRight9]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'x>-1e-6 & x<1e-6 & y>${fparse height-totalCut+9*totalCut/10} & y<${fparse height-totalCut+10*totalCut/10}'
    normal = '-1 0 0'
    new_sideset_name = cutFaceRight9
    input = cutFaceRight8
  []

  [uncut]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'x>-1e-6 & x<1e-6  & y>-1e-6 & y<${fparse height-totalCut}'
    normal = '-1 0 0'
    new_sideset_name = uncut
    input = cutFaceRight9
  []
[]
#--------------------------------------------------------------------------#

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Modules/TensorMechanics/Master]
  [all]
    strain = SMALL
    generate_output = 'stress_xx stress_yy'
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
    variable = disp_x
    x_coord_name = misfit/measurement_xcoord
    y_coord_name = misfit/measurement_ycoord
    z_coord_name = misfit/measurement_zcoord
    value_name = misfit/misfit_values
    weight_name = misfit/weight_disp_x
  []
[]

[Reporters]
  [misfit]
    type = OptimizationData
    variable_weight_names = 'weight_disp_x'
  []
  [params_cutFace]
    type = ConstantReporter
    real_vector_names = 'cutFaceForce0 cutFaceForce1 cutFaceForce2 cutFaceForce3 cutFaceForce4 cutFaceForce5 cutFaceForce6 cutFaceForce7 cutFaceForce8 cutFaceForce9'
    real_vector_values = '0; 0; 0; 0; 0; 0; 0; 0; 0; 0' # Dummy
  []
[]

[Functions]
  [cutFaceRight0_function]
    type = ParsedOptimizationFunction
    expression = 'a0'
    param_symbol_names = 'a0'
    param_vector_name = 'params_cutFace/cutFaceForce0'
  []
  [cutFaceRight1_function]
    type = ParsedOptimizationFunction
    expression = 'a1'
    param_symbol_names = 'a1'
    param_vector_name = 'params_cutFace/cutFaceForce1'
  []
  [cutFaceRight2_function]
    type = ParsedOptimizationFunction
    expression = 'a2'
    param_symbol_names = 'a2'
    param_vector_name = 'params_cutFace/cutFaceForce2'
  []
  [cutFaceRight3_function]
    type = ParsedOptimizationFunction
    expression = 'a3'
    param_symbol_names = 'a3'
    param_vector_name = 'params_cutFace/cutFaceForce3'
  []
  [cutFaceRight4_function]
    type = ParsedOptimizationFunction
    expression = 'a4'
    param_symbol_names = 'a4'
    param_vector_name = 'params_cutFace/cutFaceForce4'
  []
  [cutFaceRight5_function]
    type = ParsedOptimizationFunction
    expression = 'a5'
    param_symbol_names = 'a5'
    param_vector_name = 'params_cutFace/cutFaceForce5'
  []
  [cutFaceRight6_function]
    type = ParsedOptimizationFunction
    expression = 'a6'
    param_symbol_names = 'a6'
    param_vector_name = 'params_cutFace/cutFaceForce6'
  []
  [cutFaceRight7_function]
    type = ParsedOptimizationFunction
    expression = 'a7'
    param_symbol_names = 'a7'
    param_vector_name = 'params_cutFace/cutFaceForce7'
  []
  [cutFaceRight8_function]
    type = ParsedOptimizationFunction
    expression = 'a8'
    param_symbol_names = 'a8'
    param_vector_name = 'params_cutFace/cutFaceForce8'
  []
  [cutFaceRight9_function]
    type = ParsedOptimizationFunction
    expression = 'a9'
    param_symbol_names = 'a9'
    param_vector_name = 'params_cutFace/cutFaceForce9'
  []
[]

[VectorPostprocessors]
  [grad_bc_cutFace0]
    type = SideOptimizationNeumannFunctionInnerProduct
    variable = disp_x
    function = cutFaceRight0_function
    boundary = cutFaceRight0
  []
  [grad_bc_cutFace1]
    type = SideOptimizationNeumannFunctionInnerProduct
    variable = disp_x
    function = cutFaceRight1_function
    boundary = cutFaceRight1
  []
  [grad_bc_cutFace2]
    type = SideOptimizationNeumannFunctionInnerProduct
    variable = disp_x
    function = cutFaceRight2_function
    boundary = cutFaceRight2
  []
  [grad_bc_cutFace3]
    type = SideOptimizationNeumannFunctionInnerProduct
    variable = disp_x
    function = cutFaceRight3_function
    boundary = cutFaceRight3
  []
  [grad_bc_cutFace4]
    type = SideOptimizationNeumannFunctionInnerProduct
    variable = disp_x
    function = cutFaceRight4_function
    boundary = cutFaceRight4
  []
  [grad_bc_cutFace5]
    type = SideOptimizationNeumannFunctionInnerProduct
    variable = disp_x
    function = cutFaceRight5_function
    boundary = cutFaceRight5
  []
  [grad_bc_cutFace6]
    type = SideOptimizationNeumannFunctionInnerProduct
    variable = disp_x
    function = cutFaceRight6_function
    boundary = cutFaceRight6
  []
  [grad_bc_cutFace7]
    type = SideOptimizationNeumannFunctionInnerProduct
    variable = disp_x
    function = cutFaceRight7_function
    boundary = cutFaceRight7
  []
  [grad_bc_cutFace8]
    type = SideOptimizationNeumannFunctionInnerProduct
    variable = disp_x
    function = cutFaceRight8_function
    boundary = cutFaceRight8
  []
  [grad_bc_cutFace9]
    type = SideOptimizationNeumannFunctionInnerProduct
    variable = disp_x
    function = cutFaceRight9_function
    boundary = cutFaceRight9
  []
[]
