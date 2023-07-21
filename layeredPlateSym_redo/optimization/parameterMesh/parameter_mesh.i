# Width=25.4mm x Length=101.6mm x thickness=1.24mm -- 3.18mm Al-Al crimp around ouside
# everything is multiples of the height
unitLength = 1.3e-3 #height
totalCut = 0.80e-3
cutHalfWidth = 0.4e-3 # this is the half

xelems = '${fparse int(totalCut/0.05e-3)}'

height = ${unitLength}

[Mesh]
  parallel_type = REPLICATED
  # second_order = true
  [line]
    type = GeneratedMeshGenerator
    dim = 1
    nx = ${xelems}
    xmin = 0
    xmax = ${totalCut}
  []
  [rotate_line]
    type = TransformGenerator
    input = line
    transform = ROTATE
    vector_value = '0 0 90'
  []
  [translate_line]
    type = TransformGenerator
    input = rotate_line
    transform = TRANSLATE
    vector_value = '${cutHalfWidth} ${fparse height-totalCut} 0'
  []
[]

# [Mesh]
#   parallel_type = REPLICATED
#   [line1]
#     type = GeneratedMeshGenerator
#     dim = 1
#     nx = 4
#     xmin = 0.55e-3
#     xmax = 0.9e-3
#     bias_x = 1.3
#   []
#   [line2]
#     type = GeneratedMeshGenerator
#     dim = 1
#     nx = 6
#     xmin = 0.0
#     xmax = 0.55e-3
#     bias_x = 0.7
#   []
#   [line]
#     type = CombinerGenerator
#     inputs = 'line1 line2'
#   []
#   [rotate_line]
#     type = TransformGenerator
#     input = line
#     transform = ROTATE
#     vector_value = '0 0 90'
#   []
#   [translate_line]
#     type = TransformGenerator
#     input = rotate_line
#     transform = TRANSLATE
#     vector_value = '0.0 0.1e-3 0'
#   []
# []

# [Mesh]
#   parallel_type = REPLICATED
#   [poly]
#     type = PolyLineMeshGenerator
#     points = '0 1.0000E-04 0
#     0 2.8700E-04 0
#     0 4.1790E-04 0
#     0 5.0953E-04 0
#     0 5.7367E-04 0
#     0 6.1857E-04 0
#     0 6.5000E-04 0
#     0 7.0657E-04 0
#     0 7.8011E-04 0
#     0 8.7572E-04 0
#     0 1.0000E-03 0'
#     loop = false
#   []
# []
