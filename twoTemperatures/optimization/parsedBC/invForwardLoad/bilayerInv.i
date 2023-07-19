# Width=25.4mm x Length=101.6mm x thickness=1.24mm -- 3.18mm Al-Al crimp around ouside
# everything is multiples of the height
unitLength = 1.0e-3 #height
totalCut = 0.95e-3

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
  [cutFaceRight]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'x>-1e-6 & x<1e-6 & y>${fparse height-totalCut}'
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
  csv = true
  exodus = true
  execute_on = 'TIMESTEP_END'
[]

##---------Inverse Load------------------#

[Functions]
[invForce]
  type = PiecewiseLinear
  axis = y
  xy_data='0.00005 1325917577.5092566
  0.00010 1343984220.6842892
  0.00015 1360734234.3523903
  0.00020 1366026986.0251231
  0.00025 1349814023.50262
  0.00030 1307291116.1887987
  0.00035 1231328300.6037915
  0.00040 1118797529.6716714
  0.00045 956136583.3515517
  0.00050 728273748.4639912
  0.00055 406623327.8043258
  0.00060 -82980398.08663629
  0.00065 -1036799582.8163102
  0.00070 -1176376341.5248785
  0.00075 -1200548475.3428147
  0.00080 -1176268491.6322715
  0.00085 -1073660029.9635339
  0.00090 -828605731.0679295'
[]
[]

[BCs]
  [invForce]
    type = ADFunctionNeumannBC
    variable = disp_x
    boundary = cutFaceRight #left #cutFaceRight
    function = invForce
  []
  [left_x]
    type = ADDirichletBC
    boundary = uncut
    variable = disp_x
    value = 0.0
  []
[]
