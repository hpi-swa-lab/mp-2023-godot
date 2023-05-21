class_name AppointmentNode
extends Node3D

@onready var titleLabel = $Label3D as Label3D

var title = "":
	get:
		return title
	set(newTitle):
		title = newTitle
		titleLabel.text = title
		
var _datetime_dict

var unix_time = 0:
	get:
		return unix_time
	set(newTime):
		unix_time = newTime
		_datetime_dict = Time.get_datetime_dict_from_unix_time(newTime)

var hour:
	get:
		return _datetime_dict["hour"]

var weekday:
	get:
		return _datetime_dict["weekday"]

var durationMins = 0:
	get:
		return durationMins
	set(newDuration):
		durationMins = newDuration

# Called when the node enters the scene tree for the first time.
func _ready():
	titleLabel.text = title

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
