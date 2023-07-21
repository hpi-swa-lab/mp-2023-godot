extends Node3D
class_name ExperienceGenerator

@export var user_warning: Node3D
@export var start_position: AlignmentContainer3D

@export var alignment_container_scene: PackedScene = preload("res://scenes/AlignmentContainer3D.tscn")
@export var object_handle_scene: PackedScene = preload("res://scenes/user-study/interactable_handle.tscn")


func generate_experience(data):
	if data["view"] != "VR":
		user_warning.show()
		return
	else:
		user_warning.hide()
	
	var arrangeable = data["arrangeable"]
	
	var alignment_container: AlignmentContainer3D = alignment_container_scene.instantiate() as AlignmentContainer3D
	start_position.add_child(alignment_container)
	alignment_container.center_children = true
	alignment_container.use_child_height = true
	
	var alignment_container2: AlignmentContainer3D = alignment_container_scene.instantiate() as AlignmentContainer3D
	start_position.add_child(alignment_container2)
	alignment_container2.center_children = true
	alignment_container2.use_child_height = true
	
	start_position.position_children()
	
	var statements = data["statements"]
	
	for statement_index in statements.size():
		var container = alignment_container if statement_index < float(statements.size()) / 2.0 else alignment_container2
		var object_anchor = Node3D.new()
		
		var object_handle: ObjectHandle3D = object_handle_scene.instantiate() as ObjectHandle3D
		if arrangeable:
			object_handle.handled_node = container
		(object_handle.get_node("Label3DDMM") as Label3D).text = statements[statement_index]["text"]
		
		container.add_child(object_anchor)
		object_anchor.add_child(object_handle)
		
	alignment_container.position_children()
	alignment_container2.position_children()
