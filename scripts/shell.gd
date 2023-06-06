class_name Shell
extends Node3D

var right_hand_raycast
var active_room: Node3D
var room_switcher_menu: Node3D
var xr_interface: XRInterface

# Called when the node enters the scene tree for the first time.
func _ready():
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		var vp: Viewport = get_viewport()
		vp.use_xr = true
		L.log("OpenXR initialized.")
	else:
		L.log("OpenXR not initialized, please check if your headset is connected")
	G.shell = self
	right_hand_raycast = $"XROrigin3D/Right Hand/RightHand/RayCast3D"
	right_hand.button_released.connect(on_right_hand_button_released)
	right_hand.button_pressed.connect(on_right_hand_button_pressed)
	active_room = $"Woods Room"
	room_switcher_menu = $RoomSwitcherMenu
	
		
@onready var right_hand : XRController3D = $"XROrigin3D/Right Hand"
@onready var left_hand : XRController3D = $"XROrigin3D/Left Hand"
@onready var player_body: XRToolsPlayerBody = $XROrigin3D/PlayerBody
@onready var right_raycast: RayCast3D = $"XROrigin3D/Right Hand/RightHand/RayCast3D"

func ray_cast_on_room_switcher_menu():
	right_hand_raycast.force_raycast_update()
	if right_hand_raycast.is_colliding() and room_switcher_menu.visible:
		if right_hand_raycast.get_collider().get_parent().name == "RoomSwitcherMenu":
			var area :Area3D = right_hand_raycast.get_collider()
			var global_pos = right_hand_raycast.get_collision_point()
			# Simulate button press at the raycast collision
			var menu_pos = global_pos - area.global_position
			return [area.get_parent(), Vector2(menu_pos.z, menu_pos.y)]

var ray_cast_last_collided_at = Vector3(0,0,0)
var ray_cast_target = null		

func on_right_hand_button_pressed(button_name):
	if button_name == "ax_button":
		room_switcher_menu.visible = !room_switcher_menu.visible
	if button_name == "trigger_click":
		var ray_cast_menu_result = ray_cast_on_room_switcher_menu()
		if ray_cast_menu_result:
			var menu = ray_cast_menu_result[0]
			var menu_pos = ray_cast_menu_result[1]
			menu.press(menu_pos)
			return
		if right_hand_raycast.is_colliding():
			ray_cast_target = right_hand_raycast.get_collider()
			ray_cast_last_collided_at = right_hand_raycast.get_collision_point()

			if ray_cast_target.has_signal("pointer_pressed"):
				ray_cast_target.emit_signal("pointer_pressed", ray_cast_last_collided_at)
			elif ray_cast_target.has_method("pointer_pressed"):
				ray_cast_target.pointer_pressed(ray_cast_last_collided_at)
				
func on_right_hand_button_released(button_name):
	if button_name == "trigger_click":
		var ray_cast_menu_result = ray_cast_on_room_switcher_menu()
		if ray_cast_menu_result:
			var menu = ray_cast_menu_result[0]
			var menu_pos = ray_cast_menu_result[1]
			menu.release(menu_pos)
			return
		if right_hand_raycast.is_colliding():
			if ray_cast_target:
				if ray_cast_target.has_signal("pointer_released"):
					ray_cast_target.emit_signal("pointer_released", ray_cast_last_collided_at)
				elif ray_cast_target.has_method("pointer_released"):
					ray_cast_target.pointer_released(ray_cast_last_collided_at)
				# unset target
				ray_cast_target = null
				ray_cast_last_collided_at = Vector3(0, 0, 0)

var additional_functions: Array[Node] = []			

func switch_room(room_key):
	active_room.queue_free()
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if right_hand_raycast.is_colliding() and (room_switcher_menu.visible or $"Panel Manager".visible):
		$"XROrigin3D/Right Hand/RightHand/VisibleRay".visible = true
	else:
		$"XROrigin3D/Right Hand/RightHand/VisibleRay".visible = false
