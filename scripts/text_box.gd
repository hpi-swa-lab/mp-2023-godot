@tool
extends StaticBody3D
class_name TextBox

enum TextAlignment {
	LEFT,
	CENTER,
	RIGHT	
}

@export_multiline var text: String: 
	set(s):
		text = s
		apply_properties()

@export var resize_box: bool:
	set(r):
		resize_box = r
		apply_properties()

@export var depth: float = 0.1 :
	set(d):
		depth = d
		apply_properties()

@export var height: float:
	set(h):
		height = h
		apply_properties()

@export var width: float:
	set(w):
		width = w
		apply_properties()

@export var material: Material :
	set(m):
		material = m
		apply_properties()

@export var intended_viewing_distance : float :
	set(i):
		intended_viewing_distance = i
		apply_properties()

@export var alignment: TextAlignment = TextAlignment.CENTER :
	set(new_alignment):
		alignment = new_alignment
		apply_properties()
		
@export var enable_handle_bar: bool = true:
	set(e):	
		enable_handle_bar = e
		apply_properties()

@export var hide_box: bool = false:
	set(h):
		hide_box = h
		apply_properties()

@onready var label: Label3DDMM = $Label3DDMM
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

@export var margin_x = 0.02:
	set(m):
		margin_x = m
		apply_properties()
@export var margin_y = 0.02:
	set(m):
		margin_y = m
		apply_properties()
@export var handle_bar_padding = 0.1:
	set(h):
		handle_bar_padding = h
		apply_properties()

var z_dist = 0.0001

@onready var box_mesh: BoxMesh = mesh.mesh
@onready var collision_box : BoxShape3D = collision_shape.shape

@onready var handle: XRToolsPickable = $"InteractableHandle"
@onready var handle_mesh: MeshInstance3D = $"InteractableHandle/MeshInstance3D"
@onready var handle_collision_shape: CollisionShape3D = $"InteractableHandle/CollisionShape3D"

signal pointer_entered
signal pointer_exited

# Called when the node enters the scene tree for the first time.
func _ready():
	pointer_entered.connect(on_pointer_entered)
	pointer_exited.connect(on_pointer_exited)
	apply_properties()

func on_pointer_entered():
	pass
	#G.add_outline(mesh)
	
func on_pointer_exited():
	pass
	#G.remove_outline(mesh)

var in_update = false

var align_padding = 0.02

func apply_properties():
	if not is_inside_tree():
		if !Engine.is_editor_hint():
			return
		else:
			await ready
	if in_update: return
	in_update = true

	box_mesh.size.y = height
	box_mesh.size.x = width
	box_mesh.size.z = depth
	collision_box.size = box_mesh.size

	label.horizontal_alignment = int(alignment)

	handle.visible = enable_handle_bar
	handle.enabled = enable_handle_bar
	handle.collision_layer = 0b00000000_00010000_00000000_00000000 if enable_handle_bar else 0

	label.text = text
	label.intended_viewing_distance = intended_viewing_distance

	box_mesh.material = material
	mesh.visible = !hide_box

	if resize_box:
		rearrange()
	else:
		reposition_label()
		reposition_handle(box_mesh.size)
		var text_width = box_mesh.size.x
		# Reposition label manually in larger container
		# (with resize_box the container box will always be about as big as the text box)
		if alignment == HORIZONTAL_ALIGNMENT_LEFT:
			label.position.x = - text_width/2 + align_padding
		if alignment == HORIZONTAL_ALIGNMENT_RIGHT:
			label.position.x = text_width/2 - align_padding
	in_update = false

func rearrange():
	if not is_inside_tree(): return
	var bb = label.get_aabb().size
	box_mesh.size = Vector3(bb.x + margin_x, bb.y + margin_y, depth)
	collision_box.size = box_mesh.size
	if alignment == TextAlignment.LEFT:
		label.position.x = -bb.x / 2.0
	elif alignment == TextAlignment.RIGHT:
		label.position.x = bb.x / 2.0
	else:
		label.position.x = 0
	height = box_mesh.size.y
	width = box_mesh.size.x
	
	reposition_label()
	reposition_handle(bb)

func reposition_label():
	label.position.x = 0
	label.position.y = 0
	label.position.z = box_mesh.size.z / 2 + z_dist

var max_handle_bar_length = 0.3
var min_handle_bar_length = 0.1

func reposition_handle(bb: Vector3):
	var y_pos = - bb.y/2 - handle_bar_padding
	handle_mesh.mesh.height = max(min(max_handle_bar_length, bb.x), min_handle_bar_length)
	handle_collision_shape.shape.height = handle_mesh.mesh.height

	handle.y_offset = y_pos
	
func set_material(m):
	if !Engine.is_editor_hint():
		return
	material = m
	if not is_inside_tree(): return
	box_mesh.material = m
	
