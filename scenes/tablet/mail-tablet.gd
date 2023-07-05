extends Node3D


@onready var from: Label3DDMM = $Tablet/From
@onready var subject: Label3DDMM = $Tablet/Subject
@onready var body: Label3DDMM = $Tablet/Body


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_mailthumbnail_mail_selected(subjectSelected: String, bodySelected: String, fromSelected: String):
	from.text = fromSelected
	subject.text = subjectSelected
	body.text = bodySelected
