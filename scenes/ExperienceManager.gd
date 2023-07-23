extends Node3D
class_name ExperienceManager

signal experience_started

@export var user_info_2d_screen: Node3D
@export var user_start_2d_screen: Node3D
@export var user_menu_2d_screen: Node3D
@export var user_task_2d_screen: Node3D
@export var start_position: AlignmentContainer3D

@export var left_controller: ControllerHandler
@export var right_controller: ControllerHandler

@export var alignment_container_scene: PackedScene = preload("res://scenes/AlignmentContainer3D.tscn")
@export var object_handle_scene: PackedScene = preload("res://scenes/user-study/interactable_handle.tscn")

var object_handles: Array[ObjectHandle3D]
var animation_player: AnimationPlayer
var info_label: Label

func _ready():
	animation_player = user_info_2d_screen.get_node("AnimationPlayer") as AnimationPlayer
	info_label = user_info_2d_screen.get_node("Viewport/Control/Panel/Label") as Label

func generate_experience(data):
	if not data["view"].contains("VR"):
		animation_player.stop()
		info_label.text = "The current view is not VR.\nPlease switch to %s!" % data["view"]
		user_info_2d_screen.show()
		animation_player.play("blink_red")
		return false

	user_info_2d_screen.hide()
	
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
		if not arrangeable:
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
		
	user_info_2d_screen.hide()
	
	var task_label = user_task_2d_screen.get_node("Viewport/Control/Panel/Label") as Label
	task_label.text = data["toProof"]
	user_task_2d_screen.show()
	
	var start_button = user_start_2d_screen.get_node("Viewport/Control/Panel/StartButton") as Button
	start_button.disabled = false
	
	return true


func reset_experience():
	for object_handle in object_handles:
		object_handle.remove_handlers()
	
	object_handles.clear()
	
	for child in start_position.get_children():
		start_position.remove_child(child)
		child.queue_free()
		
	user_info_2d_screen.hide()
	user_task_2d_screen.hide()
	
	var submit_button = user_menu_2d_screen.get_node("Viewport/Control/Panel/VBoxContainer/SubmitButton") as Button
	submit_button.disabled = true
	
	var start_button = user_start_2d_screen.get_node("Viewport/Control/Panel/StartButton") as Button
	start_button.disabled = true
	
	var check_button = user_menu_2d_screen.get_node("Viewport/Control/Panel/VBoxContainer/CheckButton") as Button
	check_button.disabled = true


func _on_check_button_button_down():
	var selected_object_handles = object_handles.filter(
		func(object_handle: ObjectHandle3D): 
			return object_handle.selected)

	var correct_object_handles = object_handles.filter(
		func(object_handle: ObjectHandle3D): 
			return object_handle.correct)
	
	animation_player.stop()
	
	if selected_object_handles == correct_object_handles:
		info_label.text = "All selected are correct"
		animation_player.play("blink_green")
	else:
		info_label.text = "Some selected are incorrect"
		animation_player.play("blink_red")
	user_info_2d_screen.show()
	


func _on_start_button_button_down():
	for object_handle in object_handles:
		object_handle.show()
	
	experience_started.emit()
	
	var check_button = user_menu_2d_screen.get_node("Viewport/Control/Panel/VBoxContainer/CheckButton") as Button
	check_button.disabled = false
	
	var submit_button = user_menu_2d_screen.get_node("Viewport/Control/Panel/VBoxContainer/SubmitButton") as Button
	submit_button.disabled = false


func _on_submit_button_button_down():
	reset_experience()
