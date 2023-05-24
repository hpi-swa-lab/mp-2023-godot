extends Node3D

const SECS_PER_DAY: int = 24 * 60 * 60

const appointmentsJSON = preload("res://rooms/Calendar/appointments.json")
const appointmentScene = preload("res://rooms/Calendar/appointment.tscn")

@onready var timeYAxis = $"../time" as Label3D
@onready var weekElement = $".." as WeekElement
@onready var xAxis = $"../HeaderUnderline" as MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var weekdays = weekElement.weekdays
	
	for weekday in weekdays:
		if weekday not in appointmentsJSON.data:
			return
		var currentAppointment = appointmentsJSON.data[weekday]
		var appointmentScene = appointmentScene.instantiate() as AppointmentNode
		appointmentScene.title = currentAppointment.title
		appointmentScene.unix_time = int(currentAppointment.time)
		appointmentScene.durationMins = float(currentAppointment.duration) * 60

		add_child(appointmentScene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	# we use a timer to trigger translation because it relies on the text span
	# of a Label3D node, which is updated after all _ready functions have run
	# (for performance reasons)
	for child in get_children():
		var currentAppointment = child as AppointmentNode
		var yOffset = - currentAppointment.hour / 24.0 * timeYAxis.get_aabb().size.y
		var xOffset = - currentAppointment.weekday / 7.0 * xAxis.mesh.height
		currentAppointment.translate_object_local(Vector3(xOffset, yOffset, 0))
