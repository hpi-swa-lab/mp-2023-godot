extends XRToolsViewport

var shell: Shell

# Called when the node enters the scene tree for the first time.
func _ready():
	shell = get_parent()
	generate_menu()
	
	shell.connect("controllers_ready", _on_controllers_ready)
	
#var buttons = Dictionary()
	
func generate_menu():
	var menu_item_root = $Viewport/Control/VBoxContainer/HBoxContainer
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
		button.connect("pressed", _on_menu_button_pressed.bind(k))
#		buttons[k] = button

func _on_controllers_ready(controller: XRController3D):
	controller.connect("button_pressed", _on_controller_button_pressed)

func _on_menu_button_pressed(key: String):
	shell.switch_room(key)

func _on_controller_button_pressed(name: String):
	if name == "ax_button":
		visible = !visible
