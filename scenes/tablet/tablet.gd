@tool
extends XRToolsPickable


@onready var mesh: MeshInstance3D = $screen
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

var margin_x = 0.1
var margin_y = 0.1

var z_dist = 0.0001

@onready var box_mesh: BoxMesh = mesh.mesh
@onready var collision_box : BoxShape3D = collision_shape.shape

@onready var handle_mesh: MeshInstance3D = $"InteractableHandle/MeshInstance3D"
@onready var handle_collision_shape: CollisionShape3D = $"InteractableHandle/CollisionShape3D"

@export var disabled = false :
	set(newVal):
		disabled = newVal
		update_collision()
		
signal pointer_entered
signal pointer_exited

# Called when the node enters the scene tree for the first time.
func _ready():
	pointer_entered.connect(on_pointer_entered)
	pointer_exited.connect(on_pointer_exited)
	
	update_collision()

func on_pointer_entered():
	G.add_outline(mesh)
	
func on_pointer_exited():
	G.remove_outline(mesh)
	
func update_collision():
	if not collision_box:
		return
	if disabled == true: 
		# disable by making "empty" collision span whole tablet
		collision_box.size.z = 0.04
	else:
		collision_box.size.z = 0.001
