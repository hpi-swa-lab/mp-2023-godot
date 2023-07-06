@tool
extends XRToolsPickable

signal pointer_entered
signal pointer_exited

@onready var mesh = $MeshInstance3D
@onready var collision_shape = $"CollisionShape3D"
var pointer_on_this = false

@export var handled_node: Node3D
@export var y_offset = -0.23:
	set(o):
		y_offset = o
		apply_properties()
@export var radius = 0.01:
	set(r):
		radius = r
		apply_properties()

@export var sticky_positions: PackedVector3Array = [] # <- this makes every array the same instance :(
@export var sticky_position_relative_to_node: Node3D
@export var radius_fixed: float
@export var is_radius_fixed: bool
@export var origin: Vector3

var sticky_distance = 0.08
var original_rotation # Rotation used when sticking

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	if !Engine.is_editor_hint():
		pointer_entered.connect(on_pointer_entered)
		pointer_exited.connect(on_pointer_exited)
		original_rotation = global_rotation
	apply_properties()

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
var _original_parent = null

func on_button_press(button_name):
	if button_name == "grip_click":
		if pointer_on_this:
			#G.shell.right_hand_pickup._pick_up_object(self)
			G.shell.right_hand_pickup.picked_up_object = internal_pickable
			G.shell.right_hand_pickup.picked_up_ranged = false
			#pick_up(G.shell.right_hand_pickup, G.shell.right_hand)

			internal_pickable.pick_up(G.shell.right_hand_pickup, G.shell.right_hand)

			is_currently_picked_up = true
			_original_parent = get_parent()
			_original_parent.remove_child(self)
			internal_pickable.add_child(self)

			# Hacky way to enable this to be reparented to internalpickable (to remove shaking of handle)
			G.shell.right_hand_pickup.picked_up_object = null 

			if handled_node.has_signal("on_handle_pick_up"):
				handled_node.emit_signal("on_handle_pick_up")
	
func on_button_release(button_name):
	if button_name == "grip_click":
		if is_currently_picked_up:

			is_currently_picked_up = false
			internal_pickable.remove_child(self)
			_original_parent.add_child(self)

			# see on_button_press (hacky way must be reversed here)
			G.shell.right_hand_pickup.picked_up_object = internal_pickable
			G.shell.right_hand_pickup.drop_object()

			

			if handled_node.has_signal("on_handle_dropped"):
				handled_node.emit_signal("on_handle_dropped")

func on_input_vec2(input_name, value):
	if input_name == "primary":
		if is_currently_picked_up:
			var ray_cast_vector : Vector3 = G.shell.pointer_vec().normalized()
			internal_pickable.global_position = ray_cast_vector * 0.01 * sign(value.y) + internal_pickable.global_position

func apply_properties():
	if not is_inside_tree():
		if !Engine.is_editor_hint():
			return
		else:
			await ready
	mesh.position.y = y_offset
	collision_shape.position.y = y_offset
	collision_shape.shape.radius = radius
	mesh.mesh.top_radius = radius
	mesh.mesh.bottom_radius = radius


var sticking = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !Engine.is_editor_hint():
		if is_currently_picked_up:
			if len(sticky_positions)>0:
				for p in sticky_positions:
					var global_sticky_position = p * sticky_position_relative_to_node.transform.inverse()
					var dist = global_sticky_position.distance_to(internal_pickable.global_position)
					if dist < sticky_distance:
						sticking = true
						global_position = global_sticky_position
						global_rotation = original_rotation
						break
					sticking = false
			if is_radius_fixed:
				var moved_vector: Vector3 = internal_pickable.global_position - origin
				var handle_position: Vector2 = Vector2(moved_vector.x, moved_vector.z).normalized() * radius_fixed
				var current_y = global_position.y
				var new_global_position = Vector3(handle_position.x, current_y, handle_position.y)
				global_position = new_global_position
				look_at(Vector3(origin.x, current_y, origin.z))
				rotate_y(PI)
			elif !sticking:
				global_transform = internal_pickable.global_transform
			handled_node.global_transform = global_transform
