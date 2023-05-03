extends Node3D

var is_vr_object =true

var left_hand: XRController3D
var right_hand: XRController3D

var right_hand_in_area = false
var grabbed = false
var initial_grab_transform

# Called when the node enters the scene tree for the first time.
func _ready():
	var collision_area = get_collision_area()
	if collision_area:
		print("Collision area initialized for ", name)
		collision_area.connect("area_entered", on_area_entered)
		collision_area.connect("area_exited", on_area_exited)
		
func room_init_done():
	print("Room init done for ", name)
	right_hand.button_pressed.connect(on_right_hand_button_pressed)
	right_hand.button_released.connect(on_right_hand_button_released)

func get_collision_area():
	var collision_areas = get_children().filter(is_area_3d)
	if collision_areas.size() > 0:
		return collision_areas[0]

func is_area_3d(node):
	return node is Area3D
	
func on_area_entered(node):
	if node.get_parent() == right_hand:
		right_hand_in_area = true
		
func on_area_exited(node):
	if node.get_parent() == right_hand and right_hand_in_area:
		right_hand_in_area = false
		
func on_right_hand_button_pressed(button):
	print(button)
	if right_hand_in_area:
		print("right hand in area and button pressed")
		on_right_hand_in_object_pressed(button)
		
func on_right_hand_in_object_pressed(button):
	if button == "grip_click":
		start_grab(right_hand)
		
func start_grab(hand):
	#initial_grab_transform = transform - hand.transform
	grabbed = true

func on_right_hand_button_released(button):
	if right_hand_in_area:
		on_right_hand_in_object_released(button)
		
func on_right_hand_in_object_released(button):
	if button == "grip_click":
		grabbed = false		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if grabbed:
		transform = right_hand.transform #* initial_grab_translation
