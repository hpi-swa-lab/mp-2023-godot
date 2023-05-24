extends Node

var apps: Dictionary = {
	"email" :  {
		"scene": preload("res://rooms/Email/email_room.tscn"),
		"icon": "res://assets/img/Mail.png",
		"name": "Mail"
	},
	"adventure" : {
		"scene" :  preload("res://rooms/Adventure/woods_room.tscn"),
		"icon": "res://assets/img/Woods.png",
		"name": "Adventure"
	},
	"calendar" : {
		"scene" :  preload("res://rooms/Adventure/woods_room.tscn"),
		"icon": "res://assets/img/Calendar.png",
		"name": "Calendar"
	}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
