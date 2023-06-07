@tool
class_name AppPanel
extends Node3D

@onready var pickable: XRToolsPickable = $PickableObject
var picked_up: bool = false
var grab_start_angle: float
@export var circle_radius: float = 1
@export var panel_height: float = 1.5

# The underscored variable is needed for the setter to work in the editor
# (otherwise endless loops might occur)
# Do not use angle_on_circle, only in editor.
@export_range(-2*PI, 2*PI) var angle_on_circle: float: set = set_angle_in_editor
var _angle_on_circle: float

@export var scene_2d: PackedScene

@onready var panel_manager: PanelManager = get_parent()
@onready var viewport: SubViewport = $Viewport

# Called when the node enters the scene tree for the first time.
func _ready():
	pickable.picked_up.connect(on_picked_up)
	pickable.dropped.connect(on_dropped)
	viewport.add_child(scene_2d.instantiate())

func on_picked_up(pickable):
	picked_up = true
	grab_start_angle = _angle_on_circle
	G.shell.haptic_pulse("right", 0.1, 5)
	
func on_dropped(pickable):
	picked_up = false
	process_drag()
	
func set_angle_in_editor(a):
	set_angle_and_rearrange_panels(a)

func _set_angle(alpha):
	var base_vec = Vector2(0, circle_radius)
	var x = base_vec.x
	var y = base_vec.y
	var new_vec = Vector2(x * cos(alpha) + y * sin(alpha), -x * sin(alpha) + y * cos(alpha))
	new_vec = new_vec.normalized() * circle_radius
	var position_on_circle = Vector3(new_vec.x + global_position.x, panel_height, new_vec.y + global_position.z)
	pickable.global_position = position_on_circle
	pickable.look_at(global_position)
	pickable.rotation.x = 0
	_angle_on_circle = alpha

func set_angle_and_rearrange_panels(alpha):
	if panel_manager:
		var change_valid = panel_manager.angle_changed(alpha, grab_start_angle, self)
		if change_valid:
			_set_angle(alpha)
		else:
			G.shell.haptic_pulse("right",0.1, 2)
		
func process_drag():
	var picked_up_position = pickable.global_position
	var moved_vector =  (picked_up_position - global_position)
	moved_vector.y = 0 # We do not care about the height, since we want to keep it anyway		
	var base_vec = Vector2(0, circle_radius)
	var angle = -base_vec.angle_to(Vector2(moved_vector.x, moved_vector.z))
	set_angle_and_rearrange_panels(angle)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if picked_up:
		process_drag()
		
