extends XRToolsPickable
class_name ObjectHandle3D

signal pointer_entered
signal pointer_exited

@onready var mesh = $MeshInstance3D
@onready var collision_shape = $"CollisionShape3D"
@export var handled_node: Node3D
# don't change in inspector (only for reading purposes)
@export var correct = false
@export var selected = false

var pointer_on_this = false
var is_currently_picked_up = false
var _original_handled_parent = null

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	if !Engine.is_editor_hint():
		pointer_entered.connect(on_pointer_entered)
		pointer_exited.connect(on_pointer_exited)

var initialized = false
func ready_in_shell():
	G.shell.right_hand_button_pressed_handlers.append(on_button_press)
	G.shell.right_hand_button_released_handlers.append(on_button_release)
	G.shell.right_hand_input_vec2_handlers.append(on_input_vec2)
	
	G.shell.left_hand_button_pressed_handlers.append(on_button_press)
	G.shell.left_hand_button_released_handlers.append(on_button_release)
	G.shell.left_hand_input_vec2_handlers.append(on_input_vec2)
	
	initialized = true

func remove_handlers():
	G.shell.right_hand_button_pressed_handlers.erase(on_button_press)
	G.shell.right_hand_button_released_handlers.erase(on_button_release)
	G.shell.right_hand_input_vec2_handlers.erase(on_input_vec2)
	
	G.shell.left_hand_button_pressed_handlers.erase(on_button_press)
	G.shell.left_hand_button_released_handlers.erase(on_button_release)
	G.shell.left_hand_input_vec2_handlers.erase(on_input_vec2)

func on_pointer_entered():
	if !initialized:
		ready_in_shell()
	G.add_outline(mesh)
	pointer_on_this = true
	
func on_pointer_exited():
	G.remove_outline(mesh)
	pointer_on_this = false
	
func _process(delta):
	if is_currently_picked_up:
		look_at(get_viewport().get_camera_3d().global_position)
		rotate_object_local(Vector3.UP, PI)

func on_button_press(button_name, hand, pickup):
	if pointer_on_this:
		if button_name == "trigger_click":
			if handled_node != null:
				_original_handled_parent = handled_node.get_parent()
			else:
				look_at(get_viewport().get_camera_3d().global_position)
				rotate_object_local(Vector3.UP, PI)
			
			pick_up(pickup, hand)
			
			if handled_node != null:
				handled_node.reparent(self)

			is_currently_picked_up = true

			# Hacky way to enable this to be reparented to internalpickable (to remove shaking of handle)
			pickup.picked_up_object = null

			if handled_node != null and handled_node.has_signal("on_handle_pick_up"):
				handled_node.emit_signal("on_handle_pick_up")
				
		if button_name == "ax_button":
			selected = !selected
			if selected:
				(mesh.mesh.surface_get_material(0) as StandardMaterial3D).albedo_color = Color.BLUE
				(get_node("Label3DDMM") as Label3D).modulate = Color.WHITE
			else:
				(mesh.mesh.surface_get_material(0) as StandardMaterial3D).albedo_color = Color.WHITE
				(get_node("Label3DDMM") as Label3D).modulate = Color.BLACK

func on_button_release(button_name, pickup):
	if button_name == "trigger_click":
		if is_currently_picked_up:
			is_currently_picked_up = false

			if handled_node != null:
				handled_node.reparent(_original_handled_parent)
			
			# see on_button_press (hacky way must be reversed here)
			pickup.picked_up_object = self
			pickup.drop_object()

			if handled_node != null and handled_node.has_signal("on_handle_dropped"):
				handled_node.emit_signal("on_handle_dropped")

func on_input_vec2(input_name, value):
	if input_name == "primary":
		if is_currently_picked_up:
			return
#			var ray_cast_vector : Vector3 = G.shell.pointer_vec().normalized()
#			global_position = ray_cast_vector * 0.01 * sign(value.y) + global_position
