extends Node3D

const SECS_PER_DAY: int = 24 * 60 * 60

const weekElement = preload("res://rooms/Calendar/Week/week_element.tscn")
@onready var right_hand : XRController3D = get_node("/root/Shell/XROrigin3D/Right Hand")

var gap: float = 0.1
var visible_children = 2

# Called when the node enters the scene tree for the first time.
func _ready():	
	var today = Time.get_unix_time_from_system()
	var todayWeekday = Time.get_date_dict_from_system().weekday
	# monday has weekday value 1
	var lastMonday = today - ((todayWeekday - 1) * SECS_PER_DAY) if todayWeekday > 0 else today - 6 * SECS_PER_DAY
	var weekElem = init_WeekElem(lastMonday)
	weekElem.transform = $"../View".transform
	weekElem.visible = true
	
	var cs = $"../View/CollisionShape3D" as CollisionShape3D
	var bs = cs.shape as BoxShape3D
	bs.size.x = weekElem.aabb.size.x * visible_children
	
	self.add_child(weekElem)
	
	for _i in range(visible_children * 2):
		self.add_left()
	
	for _i in range(visible_children * 2):
		self.add_right()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_view_area_entered(area):
	if (area is WeekElement):
		var x = x_movement()
		if (x > 0):
			add_right()
			self.remove_child(self.get_child(0))
		if (x < 0):
			add_left()
			self.remove_child(self.get_child(-1))
		
		area.visible = true

func _on_view_area_exited(area):
	if (area is WeekElement):
		area.visible = false

func x_movement():
	if right_hand == null: return
	var controller_input = right_hand.get_vector2("primary").x
	return controller_input
	
func add_right():
	var rightmostElem = self.get_child(-1) as WeekElement
	var weekElem = init_WeekElem(rightmostElem.unix_time_start_of_week + 7 * SECS_PER_DAY)
	weekElem.transform = rightmostElem.transform
	var xExtent = weekElem.aabb.size.x
	weekElem.translate_object_local(Vector3(-gap - xExtent, 0, 0))
	self.add_child(weekElem)
	return weekElem
	
func add_left():
	var leftmostElem = self.get_child(0) as WeekElement
	var weekElem = init_WeekElem(leftmostElem.unix_time_start_of_week - 7 * SECS_PER_DAY)
	weekElem.transform = leftmostElem.transform
	var xExtent = weekElem.aabb.size.x
	weekElem.translate_object_local(Vector3(gap + xExtent, 0, 0))
	self.add_child(weekElem)
	self.move_child(weekElem, 0)
	return weekElem

func init_WeekElem(unix_monday_time: int):
	var weekElement = weekElement.instantiate() as WeekElement
	weekElement.unix_time_start_of_week = unix_monday_time
	weekElement.visible = false
	return weekElement
