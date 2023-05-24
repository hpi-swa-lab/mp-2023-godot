extends Node3D

const SECS_PER_DAY: int = 24 * 60 * 60

const dayElementScene = preload("res://rooms/Calendar/Day/day_element.tscn")
@onready var right_hand : XRController3D = get_node("/root/Shell/XROrigin3D/Right Hand")

var gap: float = 0.1
var visible_children = 7

# Called when the node enters the scene tree for the first time.
func _ready():	
	var today = Time.get_unix_time_from_system()
	var dayElem = init_DayElem(today)
	dayElem.transform = $"../View".transform
	dayElem.visible = true
	
	var cs = $"../View/CollisionShape3D" as CollisionShape3D
	var bs = cs.shape as BoxShape3D
	bs.size.x = dayElem.aabb.size.x * visible_children
	
	self.add_child(dayElem)
	
	for _i in range(visible_children * 2):
		self.add_left()
	
	for _i in range(visible_children * 2):
		self.add_right()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_view_area_entered(area):
	if (area is DayElement):
		var x = x_movement()
		if (x > 0):
			add_right()
			self.remove_child(self.get_child(0))
		if (x < 0):
			add_left()
			self.remove_child(self.get_child(-1))
		
		area.visible = true

func _on_view_area_exited(area):
	if (area is DayElement):
		area.visible = false

func x_movement():
	if right_hand == null: return
	var controller_input = right_hand.get_vector2("primary").x
	return controller_input
	
func add_right():
	var rightmostElem = self.get_child(-1) as DayElement
	var dayElem = init_DayElem(rightmostElem.unix_time + SECS_PER_DAY)
	dayElem.transform = rightmostElem.transform
	var xExtent = dayElem.aabb.size.x
	dayElem.translate_object_local(Vector3(-gap - xExtent, 0, 0))
	self.add_child(dayElem)
	return dayElem
	
func add_left():
	var leftmostElem = self.get_child(0) as DayElement
	var dayElem = init_DayElem(leftmostElem.unix_time - SECS_PER_DAY)
	dayElem.transform = leftmostElem.transform
	var xExtent = dayElem.aabb.size.x
	dayElem.translate_object_local(Vector3(gap + xExtent, 0, 0))
	self.add_child(dayElem)
	self.move_child(dayElem, 0)
	return dayElem

func init_DayElem(unix_time: int):
	var dayElem = dayElementScene.instantiate() as DayElement
	dayElem.unix_time = unix_time
	dayElem.visible = false
	return dayElem
