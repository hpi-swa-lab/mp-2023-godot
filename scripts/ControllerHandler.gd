extends XRController3D
class_name ControllerHandler

@onready var hand_model: XRToolsHand = $Hand
@onready var function_pickup: XRToolsFunctionPickup = $FunctionPickup
@onready var function_pointer: XRToolsFunctionPointer = $FunctionPointer

var is_active = false

func disable_controller_functions():
	function_pickup.enabled = false
	function_pointer.enabled = false
	is_active = false

func enable_controller_functions():
	function_pickup.enabled = true
	function_pointer.enabled = true
	is_active = true
