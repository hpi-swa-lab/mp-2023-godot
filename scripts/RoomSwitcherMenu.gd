extends Node3D

var mail_button: TextureButton
var adventure_button: TextureButton
var shell

# Called when the node enters the scene tree for the first time.
func _ready():
	mail_button = null # $SubViewport/Control/VBoxContainer/HBoxContainer/MailPanel/MailIcon
	adventure_button = null # $SubViewport/Control/VBoxContainer/HBoxContainer/AdventurePanel/AdventureIcon
	shell = get_parent()
	generate_menu()
	
var buttons = Dictionary()
	
func generate_menu():
	var menu_item_root = $SubViewport/Control/VBoxContainer/HBoxContainer
	for k in A.apps.keys():
		var app_spec = A.apps[k]
		var panel = VBoxContainer.new()
		var button = TextureButton.new()
		var label = Label.new()
		panel.add_child(button)
		panel.add_child(label)
		button.texture_normal = ResourceLoader.load(app_spec["icon"])
		label.text = app_spec["name"]
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		var label_settings = LabelSettings.new()
		label_settings.font_size = 40
		label.label_settings = label_settings
		menu_item_root.add_child(panel)
		buttons[button] = k
	

func pos_is_in_rect(pos, rect):
	var startx = rect.position.x
	var starty = rect.position.y
	var endx = rect.end.x
	var endy = rect.end.y
	return pos.x >= startx and pos.x <= endx and pos.y >= starty and pos.y <= endy

func area_pos_to_menu_pos(area_local_pos):
	var area_shape = $Area3D/CollisionShape3D 
	var area_width = area_shape.shape.size.x
	var area_height = area_shape.shape.size.y
	var x = area_local_pos.x
	var y = area_local_pos.y
	# Center to top left
	x += area_width/2
	y = - y +  area_height/2
	# Normalize
	x /= area_width
	y /= area_height
	
	var view_port_shape = $SubViewport
	var view_port_width = view_port_shape.size.x
	var view_port_height = view_port_shape.size.y
	
	x *= view_port_width
	y *= view_port_height
	return Vector2(x,y)
	
	

func press(area_local_pos):
	var menu_pos = area_pos_to_menu_pos(area_local_pos)
	for button in buttons.keys():
		if pos_is_in_rect(menu_pos, button.get_global_rect()):
			button.modulate = Color("#636363")
		
func release(area_local_pos):
	var menu_pos = area_pos_to_menu_pos(area_local_pos)
	for button in buttons.keys():	
		if pos_is_in_rect(menu_pos, button.get_global_rect()):
			var app = buttons[button]
			shell.switch_room(app)
			button.modulate = Color.WHITE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
