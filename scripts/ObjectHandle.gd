extends XRToolsPickable
class_name ObjectHandle3D

signal pointer_entered
signal pointer_exited

@onready var mesh = $MeshInstance3D
@onready var collision_shape = $"CollisionShape3D"
@export var handled_node: Node3D

var pointer_on_this = false

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
	initialized = true

func on_pointer_entered():
	if !initialized:
		ready_in_shell()
	G.add_outline(mesh)
	pointer_on_this = true
	
func on_pointer_exited():
	G.remove_outline(mesh)
	pointer_on_this = false

var is_currently_picked_up = false
var _original_handled_parent = null
var selected = false

func on_button_press(button_name):
	if pointer_on_this:
		if button_name == "grip_click":
			if handled_node != null:
				_original_handled_parent = handled_node.get_parent()
			
			pick_up(G.shell.right_hand_pickup, G.shell.right_hand)
			
			if handled_node != null:
				handled_node.reparent(self)

			is_currently_picked_up = true

			# Hacky way to enable this to be reparented to internalpickable (to remove shaking of handle)
			G.shell.right_hand_pickup.picked_up_object = null

			if handled_node != null and handled_node.has_signal("on_handle_pick_up"):
				handled_node.emit_signal("on_handle_pick_up")
				
		if button_name == "trigger_click":
			selected = !selected
			if selected:
				(mesh.mesh.surface_get_material(0) as StandardMaterial3D).albedo_color = Color.BLUE
			else:
				(mesh.mesh.surface_get_material(0) as StandardMaterial3D).albedo_color = Color.WHITE
	
func on_button_release(button_name):
	if button_name == "grip_click":
		if is_currently_picked_up:
			is_currently_picked_up = false
			
			if handled_node == null or _original_handled_parent == null:
				print("something went wrong")

			if handled_node != null:
				handled_node.reparent(_original_handled_parent)
			
			# see on_button_press (hacky way must be reversed here)
			G.shell.right_hand_pickup.picked_up_object = self
			G.shell.right_hand_pickup.drop_object()

			if handled_node != null and handled_node.has_signal("on_handle_dropped"):
				handled_node.emit_signal("on_handle_dropped")

func on_input_vec2(input_name, value):
	if input_name == "primary":
		if is_currently_picked_up:
			var ray_cast_vector : Vector3 = G.shell.pointer_vec().normalized()
			global_position = ray_cast_vector * 0.01 * sign(value.y) + global_position
