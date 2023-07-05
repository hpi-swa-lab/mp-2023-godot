extends XRToolsPickable

signal pointer_entered
signal pointer_exited

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var surface: StandardMaterial3D
var pointer_on_this = false
@onready var parent

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	pointer_entered.connect(on_pointer_entered)
	pointer_exited.connect(on_pointer_exited)
	parent = get_parent()
	surface = mesh.get_surface_override_material(0) as StandardMaterial3D
	if not parent.show:
		surface.albedo_color.a = 0

var initialized = false
func ready_in_shell():
	G.shell.right_hand_button_pressed_handlers.append(on_button_press)
	G.shell.right_hand_button_released_handlers.append(on_button_release)
	G.shell.right_hand_input_vec2_handlers.append(on_input_vec2)
	initialized = true

func on_pointer_entered():
	if !initialized:
		ready_in_shell()
	if parent.show: # preview
		surface.albedo_color.a = 0.8
	else:
		surface.albedo_color.a = 0.5
	pointer_on_this = true
	
func on_pointer_exited():
	if parent.show: # end preview
		surface.albedo_color.a = 1
	else:
		surface.albedo_color.a = 0
	pointer_on_this = false

func on_button_press(button_name):
	if button_name == "grip_click":
		if pointer_on_this and parent.show: # set invisible
			parent.show = false
			surface.albedo_color.a = 0
		elif pointer_on_this and not parent.show: # set visible
			parent.show = true
			surface.albedo_color.a = 1
	
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
