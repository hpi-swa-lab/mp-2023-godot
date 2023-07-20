@tool
extends Node3D
class_name AlignmentContainer3D

@export var extend: float:
	set(new_extend):
		extend = new_extend
		position_children()

@export var is_horizontal: bool:
	set(new_is_horizontal):
		is_horizontal = new_is_horizontal
		position_children()

@export var center_children: bool:
	set(new_center_children):
		center_children = new_center_children
		position_children()

# extend will be ignored and sum of child height used
@export var use_child_height: bool:
	set(new_use_child_height):
		use_child_height = new_use_child_height
		position_children()


func position_children(node = null):
	var children = get_children()
	if node != null and children.has(node):
		children.remove_at(children.find(node))
	var child_count = children.size()
	var offset = 0.0
	
	var height = extend
	
	if use_child_height:
		var total_child_height = 0.0
		for child in children:
			total_child_height += ((child.get_node("InteractableHandle/CollisionShape3D") as CollisionShape3D).shape as BoxShape3D).size.y
		height = total_child_height

	if center_children:
		offset = height / 2

	for i in child_count:
		var child = children[i]
		if child is Node3D:
			var axis_pos = height * (i + 0.5) / child_count - offset
			if is_horizontal:
				(child as Node3D).position.x = axis_pos
				(child as Node3D).position.y = 0
			else:
				(child as Node3D).position.x = 0
				(child as Node3D).position.y = axis_pos


func _on_child_entered_tree(node):
	if !Engine.is_editor_hint():
		return
	
	position_children()


func _on_child_exiting_tree(node):
	if !Engine.is_editor_hint():
		return
	
	position_children(node)
