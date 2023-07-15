# Width=25.4mm x Length=101.6mm x thickness=1.24mm -- 3.18mm Al-Al crimp around ouside
# everything is multiples of the height
unitLength = 1.3e-3 #height
yCut = 0.4e-3
cutHalfWidth = 0.4e-3 # this is the half

height = ${unitLength}
lengthMultiple = 4
length = '${fparse lengthMultiple*unitLength}'

lengthBehindCut = '${fparse -2*unitLength}'
bbLowX = '${fparse lengthBehindCut-1e-6}'
bbHiX = '${fparse lengthBehindCut+1e-6}'

yelems = 40
xelems = '${fparse int((length-lengthBehindCut)/height)*yelems}'

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Mesh]
  [gen]
    type = GeneratedMeshGenerator
    dim = 2
    nx = ${xelems}
    ny = ${yelems}
    xmin = ${lengthBehindCut}
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
    bottom_left = '${bbLowX} -1e-6 0'
    top_right = '${bbHiX} 1e-6 0'
  []

  #######------CUT-------#######
  [cut]
    type = ParsedSubdomainMeshGenerator
    input = bottomLeftNode
    combinatorial_geometry = 'x>${fparse -cutHalfWidth} & x<${cutHalfWidth} & y>${fparse (1.3e-3)-yCut}'
    block_id = 99
  []
  [del]
    type = BlockDeletionGenerator
    input = cut
    block = '99'
  []
  [cut_face]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'x>${fparse -cutHalfWidth} & x<${cutHalfWidth} & y>${fparse (1.3e-3)-yCut}'
    # included_subdomain_ids = '1'
    normal = '-1 0 0'
    new_sideset_name = cut_face
    input = del
  []
[]

[Problem]
  solve = true
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
    boundary = left
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
[]
[VectorPostprocessors]
  [point_sample]
    type = PointValueSampler
    variable = 'disp_y'
    points = "${fparse 0.5*unitLength} ${fparse height-1e-6} 0
              ${fparse 1*unitLength} ${fparse height-1e-6} 0
              ${fparse 2*unitLength} ${fparse height-1e-6} 0
              ${fparse 3*unitLength} ${fparse height-1e-6} 0
              ${fparse 4*unitLength} ${fparse height-1e-6} 0"
    sort_by = id
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
  file_base = forward
  csv = true
  exodus = true
[]

##---------Optimization stuff------------------#

[Functions]
  [cut_face_function]
    type = ParsedOptimizationFunction
    expression = 'a + b*y'
    param_symbol_names = 'a b'
    param_vector_name = 'params_cut_face/vals'
  []
[]
[Reporters]
  [params_cut_face]
    type = ConstantReporter
    real_vector_names = 'vals'
    real_vector_values = '17617629.829445 19910.815409935'
  []
[]
[BCs]
  [cut_face]
    type = FunctionNeumannBC
    variable = disp_x
    boundary = cut_face
    function = cut_face_function
  []
[]
