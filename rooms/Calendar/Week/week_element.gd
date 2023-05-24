class_name WeekElement
extends Area3D

const SECS_PER_DAY: int = 24 * 60 * 60

var title = "16.5.2023":
	set(newTitle):
		title = newTitle
	get:
		return title

var unix_time_start_of_week = 0:
	set(newTime):
		unix_time_start_of_week = newTime
		var date = Time.get_date_dict_from_unix_time(unix_time_start_of_week)
		self.title = str(date["month"]) + " " + str(date["year"])
	get:
		return unix_time_start_of_week

var aabb = AABB():
	get:
		var cs = $Pane as MeshInstance3D
		return cs.get_aabb()

var weekdays:
	get:
		var days = []
		for i in range(7):
			var u_time = unix_time_start_of_week + i * SECS_PER_DAY
			var dayString = Time.get_date_string_from_unix_time(u_time)
			days.append(dayString)
		return days

# Called when the node enters the scene tree for the first time.
func _ready():
	$title.text = title
	var children = $columns.get_children()
	var latestMonday = Time.get_date_dict_from_unix_time(unix_time_start_of_week)
	for i in children.size():
		var day = Time.get_date_dict_from_unix_time(unix_time_start_of_week + i * SECS_PER_DAY)
		(children[i] as Label3D).text = weekdayToString(day["weekday"]) + " " + str(day["day"])

	var cs = $CollisionShape3D as CollisionShape3D
	cs.make_convex_from_siblings()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func weekdayToString(weekday):
	match weekday:
		0: return "Sun"
		1: return "Mon"
		2: return "Tue"
		3: return "Wed"
		4: return "Thu"
		5: return "Fri"
		6: return "Sat"
