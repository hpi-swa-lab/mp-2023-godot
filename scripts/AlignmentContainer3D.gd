@tool
extends Node3D

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


func position_children(node = null):
	var children = get_children()
	if node != null and children.has(node):
		children.remove_at(children.find(node))
	var child_count = children.size()
	var offset = 0.0

	if center_children:
		offset = extend / 2

	for i in child_count:
		var child = children[i]
		if child is Node3D:
			var axis_pos = extend * (i + 0.5) / child_count - offset
			if is_horizontal:
				(child as Node3D).position.x = axis_pos
				(child as Node3D).position.y = 0
			else:
				(child as Node3D).position.x = 0
				(child as Node3D).position.y = axis_pos


func _on_child_entered_tree(node):
	position_children()


func _on_child_exiting_tree(node):
	position_children(node)
