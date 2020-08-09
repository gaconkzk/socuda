# Currently broken unless Godot makes this kind of thing possible:
# https://github.com/godotengine/godot/issues/21461
# https://github.com/godotengine/godot-proposals/issues/279

# Calculates the 2D transformation from a 3D position and a Basis25D.

class_name Transform25D

var spatial_position: Vector3 = Vector3()
var basic : Basic25D

func flat_transform():
  return Transform2D(0, flat_position())

func flat_position():
  var pos = spatial_position.x * basic.x
  pos += spatial_position.y * basic.y
  pos += spatial_position.z * basic.z
  return pos

func _init(basic25d):
  basic = basic25d
