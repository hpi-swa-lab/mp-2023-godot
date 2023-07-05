@tool
extends Node3D

signal mail_selected(subject, body, from)

@onready var subjectNode: Label3DDMM = $subject
@onready var bodyNode: Label3DDMM = $body
@onready var mesh: MeshInstance3D = $InteractableHandle/MeshInstance3D

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

# Called when the node enters the scene tree for the first time.
func _ready():
	updateSubjectAndLabelNodes()
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

func updateSubjectAndLabelNodes():
	if subjectNode:
			subjectNode.text = subject.substr(0, 15) + "..."
	if bodyNode:
			bodyNode.text = body.substr(0, 50) + "..."
