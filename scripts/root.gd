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
	else:
		print("OpenXR not initialised, please check if your headset is connected")
	right_hand_raycast = $"XROrigin3D/Right Hand/RightHand/RayCast3D"
	right_hand.button_released.connect(on_right_hand_button_released)
	right_hand.button_pressed.connect(on_right_hand_button_pressed)
	active_room = $"Woods Room"
	room_switcher_menu = $RoomSwitcherMenu
	
		
@onready var right_hand : XRController3D = $"XROrigin3D/Right Hand"
@onready var primary_camera: XRCamera3D = $"XROrigin3D/XRCamera3D"

func ray_cast_on_room_switcher_menu():
	right_hand_raycast.force_raycast_update()
	if right_hand_raycast.is_colliding() and room_switcher_menu.visible:
		if right_hand_raycast.get_collider().get_parent().name == "RoomSwitcherMenu":
			var area :Area3D = right_hand_raycast.get_collider()
			var global_pos = right_hand_raycast.get_collision_point()
			# Simulate button press at the raycast collision
			var menu_pos = global_pos - area.global_position
			return [area.get_parent(), Vector2(menu_pos.z, menu_pos.y)]
		
func on_right_hand_button_pressed(button_name):
	if button_name == "ax_button":
		room_switcher_menu.toggle_visibility()
	if button_name == "grip_click":
		var ray_cast_result = ray_cast_on_room_switcher_menu()
		if ray_cast_result:
			var menu = ray_cast_result[0]
			var menu_pos = ray_cast_result[1]
			menu.press(menu_pos)
				
func on_right_hand_button_released(button_name):
	if button_name == "grip_click":
		var ray_cast_result = ray_cast_on_room_switcher_menu()
		if ray_cast_result:
			var menu = ray_cast_result[0]
			var menu_pos = ray_cast_result[1]
			menu.release(menu_pos)
				
func switch_room(room_key):
	active_room.queue_free()
	var new_room = A.apps[room_key]["scene"].instantiate()
	active_room = new_room
	add_child(new_room)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if right_hand_raycast.is_colliding() and room_switcher_menu.visible:
		$"XROrigin3D/Right Hand/RightHand/VisibleRay".visible = true
	else:
		$"XROrigin3D/Right Hand/RightHand/VisibleRay".visible = false
