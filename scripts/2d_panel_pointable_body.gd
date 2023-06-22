extends StaticBody3D

signal pointer_pressed(at)
signal pointer_released(at)
signal pointer_moved(from, to)
signal pointer_entered()
signal pointer_exited()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Adapted from XRTools Viewport2Din3D
var screen_size = Vector2(1.3,1)
@export var vp: SubViewport

var mouse_mask = 0


func global_to_viewport(p_at):
	var t = $CollisionShape3D.global_transform
	var at = t.inverse() * p_at
	var viewport_size = vp.size

	# Convert to screen space
	at.x = ((at.x / screen_size.x) + 0.5) * viewport_size.x
	at.y = (0.5 - (at.y / screen_size.y)) * viewport_size.y

	return Vector2(at.x, at.y)
	
func _on_pointer_moved(from, to):
	var local_from = global_to_viewport(from)
	var local_to = global_to_viewport(to)

	# Let's mimic a mouse
	var event = InputEventMouseMotion.new()
	event.set_position(local_to)
	event.set_global_position(local_to)
	event.set_relative(local_to - local_from) # should this be scaled/warped?
	event.set_button_mask(mouse_mask)
	event.set_pressure(mouse_mask)

	if vp:
		vp.push_input(event)

func _on_pointer_pressed(at):
	var local_at = global_to_viewport(at)
	# Let's mimic a mouse
	mouse_mask = 1
	var event = InputEventMouseButton.new()
	event.set_button_index(1)
	event.set_pressed(true)
	event.set_position(local_at)
	event.set_global_position(local_at)
	event.set_button_mask(mouse_mask)

	if vp:
		vp.push_input(event)

func _on_pointer_released(at):
	var local_at = global_to_viewport(at)

	# Let's mimic a mouse
	mouse_mask = 0
	var event = InputEventMouseButton.new()
	event.set_button_index(1)
	event.set_pressed(false)
	event.set_position(local_at)
	event.set_global_position(local_at)
	event.set_button_mask(mouse_mask)

	if vp:
		vp.push_input(event)

