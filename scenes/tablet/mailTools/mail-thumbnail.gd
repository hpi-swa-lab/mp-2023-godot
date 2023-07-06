@tool
extends Node3D

signal mail_selected(subject, body, from)

@onready var subjectNode: Label3DDMM = $subject
@onready var bodyNode: Label3DDMM = $body
@onready var mesh: MeshInstance3D = $Background/MeshInstance3D
@onready var collider: CollisionShape3D = $Background/CollisionShape3D

@export_multiline var subject = "":
	set(newVal):
		subject = newVal
		updateSubjectAndLabelNodes()

@export_multiline var body = "":
	set(newVal):
		body = newVal
		updateSubjectAndLabelNodes()

@export var from = ""

@export var selected = false:
	set(newVal):
		selected = newVal
		updateColor()
		if selected == true:
			mail_selected.emit(subject, body, from)
			
@export var intended_viewing_distance = 0.4:
	set(newVal):
		intended_viewing_distance = newVal
		updateSubjectAndLabelNodes()
		
@export var background_size = Vector2(0.105, 0.079):
	set(newVal):
		background_size = newVal
		updateBackgroundSize(newVal)

# Called when the node enters the scene tree for the first time.
func _ready():
	updateSubjectAndLabelNodes()
	updateBackgroundSize(background_size)
	updateColor()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func updateColor():
	if not mesh:
		return
	var material = mesh.mesh.surface_get_material(0) as StandardMaterial3D
	material.albedo_color = Color(0.5, 0.5, 1, 1) if selected else Color(1, 1, 1, 1)
	
func updateBackgroundSize(new_size):
	if mesh:
		(mesh.mesh as BoxMesh).size.x = background_size.x
		(mesh.mesh as BoxMesh).size.y = background_size.y
	if collider:
		(collider.shape as BoxShape3D).size.x = background_size.x
		(collider.shape as BoxShape3D).size.y = background_size.y

func updateSubjectAndLabelNodes():
	if subjectNode:
		subjectNode.text = subject.substr(0, 15) + "..."
		subjectNode.intended_viewing_distance = intended_viewing_distance
	if bodyNode:
		bodyNode.text = body.substr(0, 50) + "..."
		bodyNode.intended_viewing_distance = intended_viewing_distance
