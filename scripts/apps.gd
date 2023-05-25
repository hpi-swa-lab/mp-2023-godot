extends Node

var apps: Dictionary = {
	"email" :  {
		"scene": preload("res://rooms/Email/email_room.tscn"),
		"icon": "res://assets/img/Mail.png",
		"name": "Mail",
		"additional_functions": { # Path to additional functions, which are added to the XRControllers when the room is loaded
			"left": "Additional Functions/Left",
			"right": "Additional Functions/Right"
		}
	},
	"adventure" : {
		"scene" :  preload("res://rooms/Adventure/woods_room.tscn"),
		"icon": "res://assets/img/Woods.png",
		"name": "Adventure"
	},
	"calendar" : {
		"scene" :  preload("res://rooms/Calendar/calendar_room.tscn"),
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
