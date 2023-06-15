@tool
extends Node3D

#@export var path_rotation: Vector3:
#	set(new_path_rotation):
#		$Internal/Path3D.rotation = new_path_rotation
#		path_rotation = new_path_rotation
#		position_children()

@export var path_start: Vector3:
	set(new_path_start):
		($Internal/Path3D as Path3D).curve.set_point_position(0, new_path_start)
		path_start = new_path_start
		position_children()
		
@export var path_end: Vector3:
	set(new_path_end):
		($Internal/Path3D as Path3D).curve.set_point_position(1, new_path_end)
		path_end = new_path_end
		position_children()
		
@export_range(0.0, 1.0) var visibility_ratio: float:
	set(new_visibility_ratio):
		visibility_ratio = new_visibility_ratio
		position_children()

@export var scroll_speed: float = 2.0
@export var max_velocity: float
@export var decceleration: float

var left_controller: XRController3D
var mails: Array
var mail_path: PathFollow3D

var progress = 0.0
var velocity = 0.0
var selected = false


# Called when the node enters the scene tree for the first time.
func _ready():
	mail_path = $Internal/Path3D/PathFollow3D
	left_controller = get_node("../XROrigin3D/Left Hand")
	
	position_children()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if left_controller == null: return
	
	var controller_input = left_controller.get_vector2("primary").y * scroll_speed
	if controller_input != 0.0:
		velocity += controller_input * delta
		velocity = sign(velocity) * min(abs(velocity), max_velocity)
		if sign(controller_input) != sign(velocity):
			velocity = 0
		progress -= controller_input * delta
		position_children()
	elif abs(velocity) > 0.01:
		print(velocity)
		velocity = sign(velocity) * (abs(velocity) - decceleration * delta)
		progress -= velocity * delta
		position_children()


func position_children():
	var children = get_children()
	children.pop_front()

	for i in children.size():
		var child = children[i]
		if child is Node3D and child != $Internal:
			var progress_ratio = calculate_progress_ratio(i, progress, children.size())
			if progress_ratio > visibility_ratio:
				(child as Node3D).visible = false
			else:
				(child as Node3D).visible = true
			(child as Node3D).position = $Internal/Path3D.transform * calculate_position(progress_ratio)


func calculate_progress_ratio(index, offset, children_size):
	var mail_progress = offset + (float(index) / float(children_size))
	return fposmod(mail_progress, 1)


func calculate_position(progress_ratio):
	mail_path.progress_ratio = progress_ratio
	return mail_path.position


func _on_box_on_pointer_entered():
	selected = true


func _on_box_on_pointer_exited():
	selected = false
