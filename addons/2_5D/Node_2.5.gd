# This node converts a 3D pointion to 2D using a 2.5D transformation matrix
# The transformation of its 2D form is controlled by its 3D child.
tool
extends Basic25D
class_name Node25D, "icons/node25d_icon.png"

# Exported spatial position for editor usage.
export(Vector3) var spatial_position setget set_spatial_position, get_spatial_position

# GDScript throws errors when Basis25D is its own structure.
# There is a broken implementation in a hidden folder.
# https://github.com/godotengine/godot/issues/21461
# https://github.com/godotengine/godot-proposals/issues/279
#var _basisX: Vector2
#var _basisY: Vector2
#var _basisZ: Vector2

# Cache the spatial stuff for internal use.
var _spatial_position: Vector3
var _spatial_node: Spatial

func _get_configuration_warning():
  if !_spatial_node:
    return "Missing spatial node, please add one"
  if _spatial_node.name != "math":
    return "Spatial node name must be `math`"
  return ""

# These are separated in case anyone wishes to easily extend Node25D
func _ready():
  Node25D_ready()

func _process(_delta):
  Node25D_process()

func _math_filter(node) -> bool:
  return node and "math" in node.name

# Call this method in _Ready, or before you run Node25DProcess.
func Node25D_ready():
  _spatial_node = CollectionsUtil.find(funcref(self, "_math_filter"), get_children())
  if !_spatial_node:
    update_configuration_warning()

# Call this method in _Process, or whenever the position of this object changes.
func Node25D_process():
  _check_view_mode()
  if _spatial_node == null:
    return
  _spatial_position = _spatial_node.translation
  
  # Transform25D
  var flat_pos = _spatial_position.x * x
  flat_pos += _spatial_position.y * y
  flat_pos += _spatial_position.z * z

  global_position = flat_pos


func get_basis():
#  return [_basisX, _basisY, _basisZ]
  return [x, y, z]


func get_spatial_position():
  if !_spatial_node:
    if get_child_count() > 0:
      _spatial_node = get_child(0)
      return _spatial_node.translation

  return _spatial_position


func set_spatial_position(value):
  _spatial_position = Vector3() if !value else value
  
  if _spatial_node:
    _spatial_node.translation = value
  else:
    if get_child_count() > 0:
      _spatial_node = CollectionsUtil.find(funcref(self, "_math_filter"), get_children())


# Check if anyone presses the view mode buttons and change the basis accordingly.
# This can be changed or removed in actual games where you only need one view mode.
func _check_view_mode():
  if Input.is_action_just_pressed("FortyFiveMode"):
    set_perspective(2)
  elif Input.is_action_just_pressed("IsometricMode"):
    set_perspective(3)
  elif Input.is_action_just_pressed("TopDownMode"):
    set_perspective(0)
  elif Input.is_action_just_pressed("FrontSideMode"):
    set_perspective(1)
  elif Input.is_action_just_pressed("ObliqueYMode"):
    set_perspective(4)
  elif Input.is_action_just_pressed("ObliqueZMode"):
    set_perspective(5)
