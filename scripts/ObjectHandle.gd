@tool
extends XRToolsPickable

signal pointer_entered
signal pointer_exited

@onready var mesh = $MeshInstance3D
@onready var collision_shape = $"CollisionShape3D"
var pointer_on_this = false

@export var handled_node: Node3D
@export var y_offset = -0.15:
	set(o):
		if !Engine.is_editor_hint():
			return
		y_offset = o
		if not is_inside_tree(): await ready
		mesh.position.y = o
		collision_shape.position.y = o

@export var sticky_positions: PackedVector3Array = []
@export var sticky_position_relative_to_node: Node3D
var sticky_distance = 0.08
var original_rotation # Rotation used when sticking

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	pointer_entered.connect(on_pointer_entered)
	pointer_exited.connect(on_pointer_exited)
	original_rotation = global_rotation

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

@onready var internal_pickable = $"InternalPickable"
var is_currently_picked_up = false

func on_button_press(button_name):
	if button_name == "grip_click":
		if pointer_on_this:
			#G.shell.right_hand_pickup._pick_up_object(self)
			G.shell.right_hand_pickup.picked_up_object = internal_pickable
			G.shell.right_hand_pickup.picked_up_ranged = false
			#pick_up(G.shell.right_hand_pickup, G.shell.right_hand)

			beam_offset = 0
			internal_pickable.pick_up(G.shell.right_hand_pickup, G.shell.right_hand)

			is_currently_picked_up = true
			if handled_node.has_signal("on_handle_pick_up"):
				handled_node.emit_signal("on_handle_pick_up")
	
func on_button_release(button_name):
	if button_name == "grip_click":
		if is_currently_picked_up:
			is_currently_picked_up = false
			G.shell.right_hand_pickup.drop_object()

			if handled_node.has_signal("on_handle_dropped"):
				handled_node.emit_signal("on_handle_dropped")

var beam_offset = 0

func on_input_vec2(input_name, value):
	if input_name == "primary":
		if is_currently_picked_up:
			var ray_cast_vector : Vector3 = G.shell.pointer_vec().normalized()
			internal_pickable.global_position = ray_cast_vector * 0.01 * sign(value.y) + internal_pickable.global_position
			beam_offset += 0.01 * sign(value.y)

var sticking = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_currently_picked_up:
		if len(sticky_positions)>0:
			for p in sticky_positions:
				var global_sticky_position = p * sticky_position_relative_to_node.transform.inverse()
				var dist = global_sticky_position.distance_to(internal_pickable.global_position)
				if dist < sticky_distance:
					print("Sticking! to ", p)
					sticking = true
					global_position = global_sticky_position
					global_rotation = original_rotation
					break
				sticking = false
		if !sticking:
			global_transform = internal_pickable.global_transform
		handled_node.global_transform = global_transform
