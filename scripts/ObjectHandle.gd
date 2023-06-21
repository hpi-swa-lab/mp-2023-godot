extends XRToolsPickable

signal pointer_entered
signal pointer_exited

@onready var mesh = $MeshInstance3D
var pointer_on_this = false
@onready var parent

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	pointer_entered.connect(on_pointer_entered)
	pointer_exited.connect(on_pointer_exited)
	parent = get_parent()


var initialized = false
func ready_in_shell():
	G.shell.right_hand_button_pressed_handlers.append(on_button_press)
	G.shell.right_hand_button_released_handlers.append(on_button_release)
	initialized = true

func on_pointer_entered():
	if !initialized:
		ready_in_shell()
	G.add_outline(mesh)
	pointer_on_this = true
	
func on_pointer_exited():
	G.remove_outline(mesh)
	pointer_on_this = false

func on_button_press(button_name):
	if button_name == "grip_click":
		if pointer_on_this:
			#G.shell.right_hand_pickup._pick_up_object(self)
			G.shell.right_hand_pickup.picked_up_object = self
			G.shell.right_hand_pickup.picked_up_ranged = false
			pick_up(G.shell.right_hand_pickup, G.shell.right_hand)
	
func on_button_release(button_name):
	if button_name == "grip_click":
		if is_picked_up():
			G.shell.right_hand_pickup.drop_object()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_picked_up():
		parent.global_transform = global_transform
