extends XRController3D
class_name ControllerHandler

@onready var hand_model: XRToolsHand = $LeftHand
@onready var function_pickup: XRToolsFunctionPickup = $FunctionPickup
@onready var function_pointer: XRToolsFunctionPointer = $FunctionPointer

func disable_controller_functions():
	function_pickup.enabled = false
	function_pointer.enabled = false

func enable_controller_functions():
	function_pickup.enabled = true
	function_pointer.enabled = true
