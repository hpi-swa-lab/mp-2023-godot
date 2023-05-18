extends Node

var apps: Dictionary = {
	"email" :  preload("res://rooms/Email/email_room.tscn"),
	"adventure" : preload("res://rooms/Adventure/woods_room.tscn")
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
