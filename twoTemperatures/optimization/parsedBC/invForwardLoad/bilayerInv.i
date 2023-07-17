# Width=25.4mm x Length=101.6mm x thickness=1.24mm -- 3.18mm Al-Al crimp around ouside
# everything is multiples of the height
unitLength = 1.3e-3 #height
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
    end_point = '${fparse (lengthMultiple-1)*unitLength-1e-6} ${fparse height-1e-6} 0'
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
    end_point = '${fparse 0.5*unitLength} 1e-6 0'
    num_points = ${yelems}
    sort_by = y
    variable = stress_xx
  []
  [sigxx_ln_2]
    type = LineValueSampler
    start_point = '${fparse 0.75*unitLength} ${fparse height-1e-6} 0'
    end_point = '${fparse 0.75*unitLength} 1e-6 0'
    num_points = ${yelems}
    sort_by = y
    variable = stress_xx
  []
  [sigxx_ln_3]
    type = LineValueSampler
    start_point = '${fparse 1.0*unitLength} ${fparse height-1e-6} 0'
    end_point = '${fparse 1.0*unitLength} 1e-6 0'
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
  type = PiecewiseConstant
  axis = y
  direction = right
  xy_data='0.0001 -167406824.82859
  0.0002 -609365604.5328
  0.0003 -875700992.53647
  0.0004 -1134870065.1419
  0.0005 -1401280831.4933
  0.0006 -1671534412.0804
  0.0007 -1396079182.0423
  0.0008 -1168006935.0171
  0.0009 -829168479.37037
  0.0010 -461514380.4633
  0.0011 0
  0.0012 550893457.92909'
[]
[]

[BCs]
  [invForce]
    type = FunctionNeumannBC
    variable = disp_x
    boundary = cutFaceRight
    function = invForce
  []
[]
