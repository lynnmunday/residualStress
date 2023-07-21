# Width=25.4mm x Length=101.6mm x thickness=1.24mm -- 3.18mm Al-Al crimp around ouside
# everything is multiples of the height
unitLength = 1.2e-3 #height
totalCut = 0.60e-3

height = ${unitLength}
lengthMultiple = 2
length = '${fparse lengthMultiple*unitLength}'

yelems = 48
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
  [midLayer]
    type = ParsedSubdomainMeshGenerator
    input = gen
    combinatorial_geometry = 'y>500e-6 & y<700e-6'
    block_id = 2
    block_name = 'midLayer'
  []
  [bottomLeftNode]
    type = BoundingBoxNodeSetGenerator
    input = midLayer
    new_boundary = 'bottomLeftNode'
    bottom_left = '-1e-6 -1e-6 0'
    top_right = '1e-6 1e-6 0'
  []
  #######------CUT-------#######
  [cutFaceRight]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'x>-1e-6 & x<1e-6 & y>${fparse height-totalCut} & y<${fparse height}'
    normal = '-1 0 0'
    new_sideset_name = cutFaceRight
    input = bottomLeftNode
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

[AuxVariables]
  [T]
    initial_condition = -100
  []
[]

[BCs]
  [left_x]
    type = ADDirichletBC
    boundary = uncut
    variable = disp_x
    value = 0.0
  []
  [bottomLeftNode]
    type = ADDirichletBC
    boundary = bottomLeftNode
    variable = disp_y
    value = 0.0
  []
[]

[Materials]
  [outsideElasticMatl_Al]
    type = ADComputeIsotropicElasticityTensor
    youngs_modulus = 69e9
    poissons_ratio = 0.33
    block = 0
  []
  [middleElasticMatl_U10Mo]
    type = ADComputeIsotropicElasticityTensor
    youngs_modulus = 90e9
    poissons_ratio = 0.35
    block = 2
  []
  [stress]
    type = ADComputeLinearElasticStress
  []
  [outsideThermalStrain_Al]
    type = ADComputeThermalExpansionEigenstrain
    temperature = T
    thermal_expansion_coeff = 25.1e-6 #Al6061ThermalExpansionEigenstrain T=300
    stress_free_temperature = 0
    eigenstrain_name = eigenstrain
    block = 0
  []
  [middleThermalStrain_U10Mo]
    type = ADComputeThermalExpansionEigenstrain
    temperature = T
    thermal_expansion_coeff = 15e-6 #U10MoThermalExpansionEigenstrain - Burkes  T=300
    stress_free_temperature = 0
    eigenstrain_name = eigenstrain
    block = 2
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
    real_vector_names = 'source'
    real_vector_values = '0' # Dummy
  []
[]

[Functions]
  [cutFaceRight_function]
    type = ParameterMeshFunction
    exodus_mesh = 'parameter_mesh_in_${totalCut}.e'
    family = LAGRANGE # MONOMIAL
    order = FIRST # CONSTANT
    parameter_name = params_cutFace/source
  []
[]

[BCs]
  [cutFaceRight]
    type = ADFunctionNeumannBC
    variable = 'disp_x'
    boundary = cutFaceRight
    function = cutFaceRight_function
  []
[]
##--------- Outputs ------------------#

[Outputs]
  file_base = 'cut_${totalCut}_outputs/forward'
  csv = true
  exodus = true
[]

[VectorPostprocessors]
  [Nodes]
    type = NodalValueSampler
    sort_by = id
    variable = 'disp_x disp_y'
  []
  [dispy_top]
    type = LineValueSampler
    start_point = '1e-6 ${fparse height-1e-6} 0'
    end_point = '${fparse length-1e-6} ${fparse height-1e-6} 0'
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
[]
