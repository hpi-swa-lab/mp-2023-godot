extends XRToolsPickable

signal button_pressed

signal pointer_entered
signal pointer_exited

var pointer_on_this = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print(1)
	pointer_entered.connect(on_pointer_entered)
	pointer_exited.connect(on_pointer_exited)

var initialized = false
func ready_in_shell():
	print(2)
	G.shell.right_hand_button_pressed_handlers.append(on_button_press)
	initialized = true

func on_pointer_entered():
	print(3)
	if !initialized:
		ready_in_shell()
	pointer_on_this = true
	
func on_pointer_exited():
	pointer_on_this = false

func on_button_press(button_name):
	if pointer_on_this and button_name == "grip_click":
		button_pressed.emit()
