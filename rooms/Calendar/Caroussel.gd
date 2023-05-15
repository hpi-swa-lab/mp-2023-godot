extends Node3D

@export var radius : float = 0.2

var hand: Area3D = null
var prev_position = Vector3.ZERO
var debug = true
var camera: Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	place_children_along_caroussel(0)
	camera = get_node("/root/Shell/XROrigin3D/XRCamera3D")


func _process(delta):
	for child in get_children():
		var camera_height_aligned_position = Vector3(
			camera.position.x,
			child.global_position.y,
			camera.position.z
		)
		child.look_at(camera_height_aligned_position, Vector3.UP)

func _physics_process(_delta):
	if (hand != null):
		
		if debug:
			$"../first".global_position = prev_position
			$"../second".global_position = hand.global_position
		
		var offset: float = prev_position.distance_to(hand.global_position) / (radius * 2) * (2 * PI)
		var forwardVector = camera.get_global_transform().basis.z
		var direction = (hand.global_position - forwardVector) - (prev_position - forwardVector)
		var sign = 1.0 if direction.x > 0 else -1.0
		
		if debug:
			$"../direction".text = str(sign)
		self.rotate_y(sign * offset)
		prev_position = Vector3(hand.global_position)

func place_children_along_caroussel(offset_rad: float):
	var children: Array[Node] = get_children()
	var delta: float = 2.0 * PI / children.size()
	
	var curr = offset_rad
	for child in children:
		child.position = Vector3(
			cos(curr) * radius,
			child.position.y,
			sin(curr) * radius
		)
		curr += delta


func _on_xr_tools_interactable_area_area_entered(area: Area3D):
	$"../touch".text = "inside"
	hand = area
	prev_position = Vector3(hand.global_position)

func _on_xr_tools_interactable_area_area_exited(area: Area3D):
	$"../touch".text = "outside"
	hand = null
