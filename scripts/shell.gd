class_name Shell
extends Node3D

signal controllers_ready(controller: XRController3D)

var right_hand_raycast
var active_room: Node3D
var room_switcher_menu: Node3D
var xr_interface: XRInterface
var xr_action_map: OpenXRActionMap
var xr_action_set: OpenXRActionSet

# Called when the node enters the scene tree for the first time.
func _ready():
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		var vp: Viewport = get_viewport()
		vp.use_xr = true
		xr_action_map =  ResourceLoader.load(ProjectSettings.get("xr/openxr/default_action_map"))
		L.log("OpenXR initialized.")
	else:
		L.log("OpenXR not initialized, please check if your headset is connected")
	G.shell = self
	right_hand_raycast = $"XROrigin3D/Right Hand/RightHand/RayCast3D"
#	active_room = $"Woods Room"
	room_switcher_menu = $RoomSwitcherMenu

	xr_action_set = xr_action_map.get_action_set(0)
	
	left_hand = $"XROrigin3D/Left Hand"
	right_hand = $"XROrigin3D/Right Hand"
	
	right_hand.button_released.connect(on_right_hand_button_released)
	right_hand.button_pressed.connect(on_right_hand_button_pressed)
	right_hand.input_vector2_changed.connect(on_right_hand_vec2_changed)

var left_hand : XRController3D : 
	set(new_value):
		left_hand = new_value
		controllers_ready.emit(left_hand)
		
var right_hand : XRController3D : 
	set(new_value):
		right_hand = new_value
		controllers_ready.emit(right_hand)
		
@onready var right_hand_pickup = $"XROrigin3D/Right Hand/XRToolsFunctionPickup"
@onready var player_body: XRToolsPlayerBody = $XROrigin3D/PlayerBody
@onready var right_raycast: RayCast3D = $"XROrigin3D/Right Hand/RightHand/RayCast3D"
@onready var right_pointer: XRToolsFunctionPointer = $"XROrigin3D/Right Hand/FunctionPointer"

#func ray_cast_on_room_switcher_menu():
#	right_hand_raycast.force_raycast_update()
#	if right_hand_raycast.is_colliding() and room_switcher_menu.visible:
#		if right_hand_raycast.get_collider().get_parent().name == "RoomSwitcherMenu":
#			var area :Area3D = right_hand_raycast.get_collider()
#			var global_pos = right_hand_raycast.get_collision_point()
#			# Simulate button press at the raycast collision
#			var menu_pos = global_pos - area.global_position
#			return [area.get_parent(), Vector2(menu_pos.z, menu_pos.y)]

# our own ray cast (not used)
var ray_cast_last_collided_at = Vector3(0,0,0)
var ray_cast_target = null
var right_hand_button_pressed_handlers = []
var right_hand_button_released_handlers = []
var right_hand_input_vec2_handlers = []

func on_right_hand_button_pressed(button_name):
	for handler in right_hand_button_pressed_handlers:
		handler.call(button_name)
#	if button_name == "ax_button":
#		room_switcher_menu.visible = !room_switcher_menu.visible
#		$"Panel Manager".visible = !$"Panel Manager".visible
#		$"Panel Manager".global_position = Vector3(player_body.global_position.x, 0, player_body.global_position.z)
#	if button_name == "trigger_click":
#		var ray_cast_menu_result = ray_cast_on_room_switcher_menu()
#		if ray_cast_menu_result:
#			var menu = ray_cast_menu_result[0]
#			var menu_pos = ray_cast_menu_result[1]
#			menu.press(menu_pos)
#			return
#		if right_hand_raycast.is_colliding():
#			ray_cast_target = right_hand_raycast.get_collider()
#			ray_cast_last_collided_at = right_hand_raycast.get_collision_point()
#
#			if ray_cast_target.has_signal("pointer_pressed"):
#				ray_cast_target.emit_signal("pointer_pressed", ray_cast_last_collided_at)
#			elif ray_cast_target.has_method("pointer_pressed"):
#				ray_cast_target.pointer_pressed(ray_cast_last_collided_at)
#
func on_right_hand_button_released(button_name):
	for handler in right_hand_button_released_handlers:
		handler.call(button_name)
#	if button_name == "trigger_click":
#		var ray_cast_menu_result = ray_cast_on_room_switcher_menu()
#		if ray_cast_menu_result:
#			var menu = ray_cast_menu_result[0]
#			var menu_pos = ray_cast_menu_result[1]
#			menu.release(menu_pos)
#			return
#		if right_hand_raycast.is_colliding():
#			if ray_cast_target:
#				if ray_cast_target.has_signal("pointer_released"):
#					ray_cast_target.emit_signal("pointer_released", ray_cast_last_collided_at)
#				elif ray_cast_target.has_method("pointer_released"):
#					ray_cast_target.pointer_released(ray_cast_last_collided_at)
#				# unset target
#				ray_cast_target = null
#				ray_cast_last_collided_at = Vector3(0, 0, 0)

var additional_functions: Array[Node] = []			

func switch_room(room_key):
	if active_room != null:
		active_room.queue_free()
		
	right_hand_button_pressed_handlers = []
	right_hand_button_released_handlers = []
	right_hand_input_vec2_handlers = []

	var new_room = A.apps[room_key]["scene"].instantiate()
	active_room = new_room
	add_child(new_room)
	
	# Add additional functions to XR Controllers
	for function in additional_functions:
		function.queue_free()
	additional_functions = []
	if "additional_functions" in A.apps[room_key]:
		if "left" in A.apps[room_key]["additional_functions"]:
			var left_path = NodePath(A.apps[room_key]["additional_functions"]["left"])
			var left_node = active_room.get_node(left_path)
			for function in left_node.get_children():
				function.get_parent().remove_child(function)
				left_hand.add_child(function)
				additional_functions.append(function)
				if "_controller" in function:
					function._controller = XRHelpers.get_xr_controller(function)
		if "right" in A.apps[room_key]["additional_functions"]:
			var right_path = NodePath(A.apps[room_key]["additional_functions"]["right"])
			var right_node = active_room.get_node(right_path)
			for function in right_node.get_children():
				L.log( function.name)
				function.get_parent().remove_child(function)
				right_hand.add_child(function)
				additional_functions.append(function)
				if "_controller" in function:
					function._controller = XRHelpers.get_xr_controller(function)
	player_body._movement_providers = get_tree().get_nodes_in_group("movement_providers")
	player_body._movement_providers.sort_custom(player_body.sort_by_order)
	
func haptic_pulse(side: String, duration: float, intensity: float = 10):
	var hand = right_hand if side == "right" else left_hand
	hand.trigger_haptic_pulse("haptic", 4000, intensity, duration, 0)


func on_right_hand_vec2_changed(input_name: String, value: Vector2):
	for handler in right_hand_input_vec2_handlers:
		handler.call(input_name, value)

func pointer_vec():
	var base_pointer = Vector3(0,0,-1000)
	return base_pointer *  right_pointer.global_transform.inverse()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#if right_hand_raycast.is_colliding() and (room_switcher_menu.visible or $"Panel Manager".visible):
	#	$"XROrigin3D/Right Hand/RightHand/VisibleRay".visible = true
	#else:
	#	$"XROrigin3D/Right Hand/RightHand/VisibleRay".visible = false
