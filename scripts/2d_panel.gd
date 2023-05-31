extends Node3D

@onready var pickable: XRToolsPickable = $PickableObject
var picked_up: bool = false
var circle_radius = 1
var panel_height: float = 1.5


# Called when the node enters the scene tree for the first time.
func _ready():
	pickable.picked_up.connect(on_picked_up)
	pickable.dropped.connect(on_dropped)

func on_picked_up(pickable):
	picked_up = true
	
func on_dropped():
	picked_up = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if picked_up:
		var picked_up_position = pickable.global_position
		var moved_vector =  (picked_up_position - global_position)
		moved_vector.y = 0 # We do not care about the height, since we want to keep it anyway		
		var position_on_circle =moved_vector.normalized() * circle_radius + global_position
		position_on_circle.y = panel_height
		pickable.global_position = position_on_circle
		pickable.look_at(global_position)
		pickable.rotation.x = 0
		
