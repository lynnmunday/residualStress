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

##---------Optimization stuff------------------#

[Reporters]
  [measure_data]
    type = OptimizationData
    variable = 'disp_x'
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

[BCs]
  [cutFaceRight0]
    type = ADFunctionNeumannBC
    variable = disp_x
    boundary = cutFaceRight0
    function = cutFaceRight0_function
  []
  [cutFaceRight1]
    type = ADFunctionNeumannBC
    variable = disp_x
    boundary = cutFaceRight1
    function = cutFaceRight1_function
  []
  [cutFaceRight2]
    type = ADFunctionNeumannBC
    variable = disp_x
    boundary = cutFaceRight2
    function = cutFaceRight2_function
  []
  [cutFaceRight3]
    type = ADFunctionNeumannBC
    variable = disp_x
    boundary = cutFaceRight3
    function = cutFaceRight3_function
  []
  [cutFaceRight4]
    type = ADFunctionNeumannBC
    variable = disp_x
    boundary = cutFaceRight4
    function = cutFaceRight4_function
  []
  [cutFaceRight5]
    type = ADFunctionNeumannBC
    variable = disp_x
    boundary = cutFaceRight5
    function = cutFaceRight5_function
  []
  [cutFaceRight6]
    type = ADFunctionNeumannBC
    variable = disp_x
    boundary = cutFaceRight6
    function = cutFaceRight6_function
  []
  [cutFaceRight7]
    type = ADFunctionNeumannBC
    variable = disp_x
    boundary = cutFaceRight7
    function = cutFaceRight7_function
  []
  [cutFaceRight8]
    type = ADFunctionNeumannBC
    variable = disp_x
    boundary = cutFaceRight8
    function = cutFaceRight8_function
  []
  [cutFaceRight9]
    type = ADFunctionNeumannBC
    variable = disp_x
    boundary = cutFaceRight9
    function = cutFaceRight9_function
  []
[]
##--------- Outputs ------------------#

[Outputs]
  file_base = 'cut_${totalCut}_outputs/forward'
  csv = true
  exodus = true
[]

[VectorPostprocessors]
  [dispy_ln_all]
    type = LineValueSampler
    start_point = '1e-6 ${fparse height-1e-6} 0'
    end_point = '${fparse length-1e-6} ${fparse height-1e-6} 0'
    num_points = 100
    sort_by = x
    variable = disp_y
  []
  [dispy_ln_0]
    type = LineValueSampler
    start_point = '1e-6 ${fparse height-1e-6} 0'
    end_point = '${fparse 0.25*unitLength-1e-6} ${fparse height-1e-6} 0'
    num_points = 100
    sort_by = x
    variable = disp_y
  []
  [sigxx_ln_0]
    type = LineValueSampler
    start_point = '1e-6 ${fparse height-1e-6} 0'
    end_point = '1e-6 1e-6 0'
    num_points = ${yelems}
    sort_by = y
    variable = stress_xx
  []
  [sigxx_ln_1]
    type = LineValueSampler
    start_point = '${fparse 0.5*unitLength} ${fparse height-1e-6} 0'
    end_point = '${fparse 0.25*unitLength} 1e-6 0'
    num_points = ${yelems}
    sort_by = y
    variable = stress_xx
  []
[]
