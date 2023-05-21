class_name DayElement
extends Area3D

var title = "16.5.2023":
	set(newTitle):
		title = newTitle
	get:
		return title

var unix_time = 0:
	set(newTime):
		unix_time = newTime
		var date = Time.get_date_dict_from_unix_time(unix_time)
		self.title = str(date["day"]) + "." + str(date["month"]) + "." + str(date["year"])
	get:
		return unix_time

var aabb = AABB():
	get:
		var cs = $Pane as MeshInstance3D
		return cs.get_aabb()

# Called when the node enters the scene tree for the first time.
func _ready():
	$title.text = title
	var cs = $CollisionShape3D as CollisionShape3D
	cs.make_convex_from_siblings()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
