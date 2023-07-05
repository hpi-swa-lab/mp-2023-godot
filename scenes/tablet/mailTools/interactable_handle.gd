extends XRToolsPickable

signal pointer_entered
signal pointer_exited

const colorSelected = Color(0.5, 0.5, 1, 1)
const colorUnselected = Color(1, 1, 1, 1)

@onready var mesh: MeshInstance3D = $MeshInstance3D
var surface: StandardMaterial3D

var pointer_on_this = false
@onready var parent

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	pointer_entered.connect(on_pointer_entered)
	pointer_exited.connect(on_pointer_exited)
	parent = get_parent()
	surface = mesh.mesh.surface_get_material(0) as StandardMaterial3D
	if parent.selected:
		surface.albedo_color = colorSelected

var initialized = false
func ready_in_shell():
	G.shell.right_hand_button_pressed_handlers.append(on_button_press)
	G.shell.right_hand_button_released_handlers.append(on_button_release)
	G.shell.right_hand_input_vec2_handlers.append(on_input_vec2)
	initialized = true

func on_pointer_entered():
	if !initialized:
		ready_in_shell()
	
	#if parent.selected: # preview
	#	surface.albedo_color.a = 0.8
	#else:
	#	surface.albedo_color.a = 0.5
	pointer_on_this = true
	
func on_pointer_exited():
	#if parent.selected: # end preview
	#	surface.albedo_color.a = 1
	#else:
	#	surface.albedo_color.a = 0
	pointer_on_this = false

func on_button_press(button_name):
	if button_name == "grip_click" and pointer_on_this:
		parent.selected = true

func on_button_release(button_name):
	return

func on_input_vec2(input_name, value):
	if input_name == "primary":
		if is_picked_up():
			#pause_grab()
			var ray_cast_vector : Vector3 = G.shell.pointer_vec().normalized()
			global_position = ray_cast_vector * 0.01 * sign(value.y) + global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_picked_up():
		parent.global_transform = global_transform
		var ray_cast_vector : Vector3 = G.shell.pointer_vec().normalized()
