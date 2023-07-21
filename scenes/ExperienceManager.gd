extends Node3D
class_name ExperienceManager

signal experience_started

@export var user_warning: Node3D
@export var start_position: AlignmentContainer3D

@export var left_controller: ControllerHandler
@export var right_controller: ControllerHandler

@export var alignment_container_scene: PackedScene = preload("res://scenes/AlignmentContainer3D.tscn")
@export var object_handle_scene: PackedScene = preload("res://scenes/user-study/interactable_handle.tscn")

var object_handles: Array[ObjectHandle3D]


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
		var statement = statements[statement_index]
		
		var container = alignment_container if statement_index < float(statements.size()) / 2.0 else alignment_container2
		var object_anchor = Node3D.new()
		
		var object_handle: ObjectHandle3D = object_handle_scene.instantiate() as ObjectHandle3D
		object_handle.correct = statement["correct"]
		if arrangeable:
			object_handle.handled_node = container
		(object_handle.get_node("Label3DDMM") as Label3D).text = statement["text"]
		
		container.add_child(object_anchor)
		object_anchor.add_child(object_handle)
		
		object_handles.append(object_handle)
		object_handle.hide()
		
	alignment_container.position_children()
	alignment_container2.position_children()
	
	if data["leftHand"]:
		left_controller.enable_controller_functions()
		right_controller.disable_controller_functions()
	else:
		right_controller.enable_controller_functions()
		left_controller.disable_controller_functions()


func _on_check_button_button_down():
	var selected_object_handles = object_handles.filter(
		func(object_handle: ObjectHandle3D): 
			return object_handle.selected)

	var correct_object_handles = object_handles.filter(
		func(object_handle: ObjectHandle3D): 
			return object_handle.correct)
			
	if selected_object_handles == correct_object_handles:
		print("all selected are correct")
	else:
		print("some selected are not correct")


func _on_start_button_button_down():
	for object_handle in object_handles:
		object_handle.show()
	
	experience_started.emit()
