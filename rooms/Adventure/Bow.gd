extends Node3D


var string : XRToolsPickable
var grip: XRToolsPickable
var initial_string_transform: Transform3D
@export var arrow_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	string = $Grip/String
	grip = $Grip
	
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
	
	#fire arrow
	var arrow = arrow_scene.instantiate()
	get_parent().add_child(arrow)
	var arrow_body = arrow.get_child(0)
	arrow_body.global_transform = string.global_transform
	var bow_forward = (-grip.transform.basis.x).normalized()
	arrow_body.look_at(arrow_body.transform.origin + bow_forward, Vector3(0, 1, 0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
