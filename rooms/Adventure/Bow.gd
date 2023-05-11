extends Node3D


var string : XRToolsPickable
var grip: XRToolsPickable
var initial_string_transform: Transform3D
@export var arrow_scene: PackedScene
@export var arrow_speed = 4
var aim: Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	string = $Grip/String
	grip = $Grip
	aim = $Grip/Aim
	
	print("Init bow with ", string)
	string.picked_up.connect(on_string_pull)
	string.dropped.connect(on_string_release)
	initial_string_transform = string.transform
	
func on_string_pull(arg):
	print("String PULL")
	pass
	
func on_string_release(arg):
	print("String Release")
	var string_grip_distance = string.global_position.distance_to(grip.global_position)
	string.transform = initial_string_transform
	string.inertia = Vector3(0,0,0)
	string.linear_velocity = Vector3(0,0,0)
	string.angular_velocity = Vector3(0,0,0)
	
	#fire arrow
	var arrow : RigidBody3D = arrow_scene.instantiate()

	arrow.global_transform = string.global_transform

	get_parent().add_child(arrow)
	var direction_vector = (aim.global_position - arrow.global_position).normalized()
	arrow.linear_velocity = direction_vector * arrow_speed	* ((1 +string_grip_distance) ** 2)
	print("BOWANDARROW Aim global position ", aim.global_position)
	print("BOWANDARROW Arrow global position ", arrow.global_position)
	print("BOWANDARROW Arrow lin celocity ", arrow.linear_velocity)
	arrow.look_at(aim.global_position, Vector3(0, 1, 0))
	#var bow_forward = (-grip.transform.basis.x).normalized()
	#arrow_body.look_at(arrow_body.transform.origin + bow_forward, Vector3(0, 1, 0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
