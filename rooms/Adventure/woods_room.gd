extends "res://scripts/Room.gd"

@onready var grip = $Bow/Grip
@onready var string = $Bow/String

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	grip.connect("area_entered", area_in_grip)

func area_in_grip(area):
	if area.get_parent() == right_hand:
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
