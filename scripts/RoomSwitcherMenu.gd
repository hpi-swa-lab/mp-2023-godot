extends Node3D

var mail_button: TextureButton
var adventure_button: TextureButton

# Called when the node enters the scene tree for the first time.
func _ready():
	mail_button = $SubViewport/Control/VBoxContainer/HBoxContainer/MailPanel/MailIcon
	adventure_button = $SubViewport/Control/VBoxContainer/HBoxContainer/AdventurePanel/AdventureIcon

func pos_is_in_rect(pos, rect):
	var startx = rect.position.x
	var starty = rect.position.y
	var endx = rect.end.x
	var endy = rect.end.y
	return pos.x >= startx and pos.x <= endx and pos.y >= starty and pos.y <= endy

func area_pos_to_menu_pos(area_local_pos):
	print("VRSHELL area local pos", area_local_pos)
	var area_shape = $Area3D/CollisionShape3D 
	var area_width = area_shape.shape.size.x
	var area_height = area_shape.shape.size.y
	var x = area_local_pos.x
	var y = area_local_pos.y
	# Center to top left
	x += area_width/2
	y = - y +  area_height/2
	print("VRSHELL top left origin pos", x," ", y)
	# Normalize
	x /= area_width
	y /= area_height
	print("VRSHELL normalized", x," ", y)
	
	var view_port_shape = $SubViewport
	var view_port_width = view_port_shape.size.x
	var view_port_height = view_port_shape.size.y
	
	x *= view_port_width
	y *= view_port_height
	print("VRSHELL viewport", x," ", y)
	return Vector2(x,y)
	
	

func press(area_local_pos):
	print("VRSHELL area local pos", area_local_pos)
	var menu_pos = area_pos_to_menu_pos(area_local_pos)
	print("VRSHELL control pos", menu_pos)
	print("VRSHELL mail button rect", mail_button.get_global_rect())
	print("VRSHELL adv button rect", adventure_button.get_global_rect())
	if pos_is_in_rect(menu_pos, mail_button.get_global_rect()):
		on_mail_button_pressed()
	if pos_is_in_rect(menu_pos, adventure_button.get_global_rect()):
		on_adventure_button_pressed()

func on_mail_button_pressed():
	print("VRSHELL Mail button pressed")

func on_adventure_button_pressed():
	print("VRSHELL Adventure button pressed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
