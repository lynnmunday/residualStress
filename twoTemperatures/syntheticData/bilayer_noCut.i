# Width=25.4mm x Length=101.6mm x thickness=1.24mm -- 3.18mm Al-Al crimp around ouside
# everything is multiples of the height
unitLength = 1.0e-3 #height

height = ${unitLength}
lengthMultiple = 0.5
length = '${fparse lengthMultiple*unitLength}'

yelems = 20
xelems = '${fparse int(length/height)*yelems}'

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

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
[]

[Modules/TensorMechanics/Master]
  [all]
    strain = SMALL
    eigenstrain_names = 'eigenstrain'
    generate_output = 'stress_xx stress_yy stress_xy vonmises_stress'
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
  []
[]

[ICs]
  [T_ic]
    type = FunctionIC
    variable = 'T'
    function = bilayerT
  []
[]
[Functions]
  [bilayerT]
    type = ParsedFunction
    expression ='if(y<=0.65e-3,100,-100)'
  []
[]

[BCs]
  [left_x]
    type = ADDirichletBC
    boundary = left
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
  [outsideThermalStrain_Al]
    type = ADComputeThermalExpansionEigenstrain
    temperature = T
    thermal_expansion_coeff = 25.1e-6 #Al6061ThermalExpansionEigenstrain T=300
    stress_free_temperature = 0
    eigenstrain_name = eigenstrain
  []
[]

[VectorPostprocessors]
  [Nodes]
    type = NodalValueSampler
    sort_by = id
    variable = 'disp_x disp_y'
  []
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

##############################################################
[Outputs]
  file_base = results
  csv = true
  exodus = true
  execute_on = 'TIMESTEP_END'
[]
