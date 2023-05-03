extends Node3D

var left_hand : XRController3D
var right_hand : XRController3D

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if "is_vr_object" in child: # hacky
			child.left_hand = left_hand
			child.right_hand = right_hand
			child.room_init_done()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
