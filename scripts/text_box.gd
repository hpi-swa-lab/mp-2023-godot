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
		if !Engine.is_editor_hint():
			return
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

@onready var handle_mesh: MeshInstance3D = $"InteractableHandle/MeshInstance3D"
@onready var handle_collision_shape: CollisionShape3D = $"InteractableHandle/CollisionShape3D"

signal pointer_entered
signal pointer_exited

# Called when the node enters the scene tree for the first time.
func _ready():
	pointer_entered.connect(on_pointer_entered)
	pointer_exited.connect(on_pointer_exited)

func on_pointer_entered():
	G.add_outline(mesh)
	
func on_pointer_exited():
	G.remove_outline(mesh)

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
	reposition_handle(bb)

func set_depth(d):
	if !Engine.is_editor_hint():
		return
	
	depth = d
	rearrange()

func set_text(s):
	if !Engine.is_editor_hint():
		return
	
	text = s
	label.text = s
	if resize_box:
		rearrange()
		
func reposition_label():
	label.position.z = box_mesh.size.z / 2 + z_dist

var handle_bar_padding = 0.1

func reposition_handle(bb: Vector3):
	var y_pos = - bb.y/2 - handle_bar_padding
	handle_mesh.position.y = y_pos
	handle_collision_shape.position.y = y_pos
	
func set_material(m):
	if !Engine.is_editor_hint():
		return

	material = m
	box_mesh.material = m
	
func set_text_font_size(s):
	if !Engine.is_editor_hint():
		return
	
	text_font_size = s
	label.font_size = s
	if resize_box:
		rearrange()
