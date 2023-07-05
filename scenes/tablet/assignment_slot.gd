@tool
extends Node3D

@onready var label: Label3DDMM = $Label3DDMM

# indicate whether to show the assignment slot
@export var show = true:
	set(newVal):
		show = newVal
		updateLabel()
	
@export_multiline var text = "":
	set(newVal):
		text = newVal
		updateLabel()


@export var font_size = 15:
	set(newVal):
		font_size = newVal
		updateLabel()

# Called when the node enters the scene tree for the first time.
func _ready():
	updateLabel()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func updateLabel():
	if label:
		label.visible = show
		label.text = text
		label.font_size = font_size
