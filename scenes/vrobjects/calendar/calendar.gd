extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var handle = $"Monday/Event/InteractableHandle"
	handle.sticky_position_relative_to_node = self
	var z_offset = 0.02
	handle.sticky_positions = [Vector3(0,0,z_offset), Vector3(0,0.1,z_offset), Vector3(0,0.2,z_offset), Vector3(0,0.3,z_offset)
	, Vector3(0,0.4,z_offset), Vector3(0,0.5,z_offset), Vector3(0,0.6,z_offset), Vector3(0,0.7,z_offset)]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
