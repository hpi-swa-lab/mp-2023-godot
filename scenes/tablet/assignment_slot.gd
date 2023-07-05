@tool
extends Node3D

# indicate whether to show the assignment slot
@export var show = true
@export_multiline var text = "":
	get:
		return $Label3DDMM.text
	set(newVal):
		$Label3DDMM.text = newVal

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
