[Mesh]
  parallel_type = REPLICATED
  [line]
    type = GeneratedMeshGenerator
    dim = 1
    nx = 18
    xmin = 0
    xmax = 0.9e-3
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
    vector_value = '0.0 0.1e-3 0'
  []
[]
