extends Node

var apps: Dictionary = {
	"meta_slices_2d" :  {
		"scene": func (): return load("res://scenario/meta_slices_2d.tscn"),
		"icon": "res://assets/img/Mail.png",
		"name": "Meta Slices 2D",
	},
	"vr_objects" : {
		"scene" : func (): return load("res://scenario/vr_objects.tscn"),
		"icon": "res://assets/img/Woods.png",
		"name": "VR Objects"
	},
	"tablet_2d" : {
		"scene" : func (): return load("res://scenario/tablet_2d.tscn"),
		"icon": "res://assets/img/Woods.png",
		"name": "Tablet 2D"
	},
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
