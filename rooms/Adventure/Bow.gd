extends Node3D


var string : XRToolsPickable
var initial_string_transform: Transform3D

# Called when the node enters the scene tree for the first time.
func _ready():
	string = $Grip/String
	print("Init bow with ", string)
	string.picked_up.connect(on_string_pull)
	string.dropped.connect(on_string_release)
	initial_string_transform = string.transform
	
func on_string_pull(arg):
	print("String PULL")
	pass
	
func on_string_release(arg):
	print("String Release")
	string.transform = initial_string_transform
	string.inertia = Vector3(0,0,0)
	string.linear_velocity = Vector3(0,0,0)
	string.angular_velocity = Vector3(0,0,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
