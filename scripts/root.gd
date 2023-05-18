extends Node3D

var right_hand_raycast
var active_room: Node3D
var room_switcher_menu: Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	var xr_interface: XRInterface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		var vp: Viewport = get_viewport()
		vp.use_xr = true
	right_hand_raycast = $"XROrigin3D/Right Hand/RightHand/RayCast3D"
	right_hand.button_pressed.connect(on_right_hand_button_pressed)
	active_room = $"Woods Room"
	room_switcher_menu = $RoomSwitcherMenu
	
		
@onready var right_hand : XRController3D = $"XROrigin3D/Right Hand"
		
func on_right_hand_button_pressed(button_name):
	if button_name == "ax_button":
		room_switcher_menu.visible = !room_switcher_menu.visible
	if button_name == "grip_click":
		#var woods_room_resource: PackedScene = preload("res://rooms/Adventure/woods_room.tscn")
		#var new_room = woods_room_resource.instantiate()
		#self.add_child(new_room)
		right_hand_raycast.force_raycast_update()
		if right_hand_raycast.is_colliding() and room_switcher_menu.visible:
			print("VRSHELL raycast colliding")
			if right_hand_raycast.get_collider().get_parent().name == "RoomSwitcherMenu":
				print("VRSHELL raycast colliding with menu")
				var area :Area3D = right_hand_raycast.get_collider()
				var global_pos = right_hand_raycast.get_collision_point()
				print("VRSHELL collision point ", global_pos)
				# Simulate button press at the raycast collision
				var menu_pos = global_pos - area.global_position
				print("VRSHELL pos ", menu_pos)
				area.get_parent().press(Vector2(menu_pos.z, menu_pos.y))
				
func switch_room(room_key):
	active_room.queue_free()
	var new_room = A.apps[room_key].instantiate()
	active_room = new_room
	add_child(new_room)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if right_hand_raycast.is_colliding():
		$"XROrigin3D/Right Hand/RightHand/VisibleRay".visible = true
	else:
		$"XROrigin3D/Right Hand/RightHand/VisibleRay".visible = false
