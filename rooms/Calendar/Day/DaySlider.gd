extends Node3D

@onready var right_hand : XRController3D = get_node("/root/Shell/XROrigin3D/Right Hand")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if right_hand == null: return
	var controller_input = right_hand.get_vector2("primary").x
	if controller_input != 0.0:
		$OrderedPanels.translate(Vector3(controller_input * delta * 2.0, 0, 0))
