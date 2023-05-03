extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var xr_interface: XRInterface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		var vp: Viewport = get_viewport()
		vp.use_xr = true
	right_hand.button_pressed.connect(open_room)
		
	
		
@onready var right_hand : XRController3D = $"XROrigin3D/Right Hand"
@onready var left_hand : XRController3D = $"XROrigin3D/Left Hand"
		
func open_room(name):
	if name == "ax_button":
		var woods_room_resource: PackedScene = preload("res://rooms/Adventure/woods_room.tscn")
		var new_room = woods_room_resource.instantiate()
		
		new_room.left_hand = left_hand
		new_room.right_hand = right_hand
		self.add_child(new_room)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
