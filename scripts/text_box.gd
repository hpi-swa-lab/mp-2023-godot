@tool
extends XRToolsPickable

enum TextAlignment {
	LEFT,
	CENTER,
	RIGHT
}

@export_multiline var text: String : set = set_text
@export var resize_box: bool = true
@export var depth: float = 0.1 : set = set_depth
@export var material: Material : set = set_material
@export var text_font_size : float : set = set_text_font_size
@export var alignment: TextAlignment = TextAlignment.CENTER :
	set(new_alignment):
		alignment = new_alignment
		label.horizontal_alignment = int(alignment)
		rearrange()

@onready var label: Label3D = $Label
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

var margin_x = 0.1
var margin_y = 0.1

var z_dist = 0.0001

@onready var box_mesh: BoxMesh = mesh.mesh
@onready var collision_box : BoxShape3D = collision_shape.shape

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func rearrange():
	var bb = label.get_aabb().size
	box_mesh.size = Vector3(bb.x + margin_x, bb.y + margin_y, depth)
	collision_box.size = box_mesh.size
	if alignment == TextAlignment.LEFT:
		label.position.x = -bb.x / 2.0
	elif alignment == TextAlignment.RIGHT:
		label.position.x = bb.x / 2.0
	else:
		label.position.x = 0
	
	reposition_label()

func set_depth(d):
	depth = d
	rearrange()

func set_text(s):
	text = s
	label.text = s
	if resize_box:
		rearrange()
		
func reposition_label():
	label.position.z = box_mesh.size.z / 2 + z_dist
	
func set_material(m):
	material = m
	box_mesh.material = m
	
func set_text_font_size(s):
	text_font_size = s
	label.font_size = s
	if resize_box:
		rearrange()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
