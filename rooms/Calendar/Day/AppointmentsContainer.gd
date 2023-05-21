extends Node3D

const appointmentsJSON = preload("res://rooms/Calendar/appointments.json")
const appointmentScene = preload("res://rooms/Calendar/appointment.tscn")

@onready var timeYAxis = $"../time y axis" as Label3D
@onready var dayElement = $".." as DayElement

# Called when the node enters the scene tree for the first time.
func _ready():
	var currDay = Time.get_date_string_from_unix_time(dayElement.unix_time)	
	
	if currDay not in appointmentsJSON.data:
		return
	
	var currentAppointment = appointmentsJSON.data[currDay]
	var appointmentScene = appointmentScene.instantiate() as AppointmentNode
	appointmentScene.title = currentAppointment.title
	appointmentScene.unix_time = int(currentAppointment.time)
	appointmentScene.durationMins = float(currentAppointment.duration) * 60
	
	add_child(appointmentScene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	for child in get_children():
		var appt = child as AppointmentNode
		var yOffset = - appt.hour / 24.0 * timeYAxis.get_aabb().size.y
		appt.translate_object_local(Vector3(0, yOffset, 0))
