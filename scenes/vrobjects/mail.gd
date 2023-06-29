@tool
extends Node3D

@export var subject: String:
	set(s):
		subject = s
		set_text()
@export var from: String:
	set(f):
		from = f
		set_text()
@export var to: String:
	set(t):
		to = t
		set_text()
@export_multiline var body: String:
	set(b):
		body = b
		set_text()

@onready var subject_textbox = $"TextBoxes/Subject"
@onready var from_textbox = $"TextBoxes/From"
@onready var to_textbox = $"TextBoxes/To"
@onready var body_textbox = $"TextBoxes/Body"

signal on_handle_pick_up

# Called when the node enters the scene tree for the first time.
func _ready():
	set_text()
	on_handle_pick_up.connect(on_picked_up)

func on_picked_up():
	if get_parent().has_signal("child_picked_up"):
		print("has signal")
		get_parent().emit_signal("child_picked_up", self)

func set_text():
	if not is_inside_tree():
		if !Engine.is_editor_hint():
			return
		else:
			await ready
	subject_textbox.text = subject
	from_textbox.text = from
	to_textbox.text = to
	body_textbox.text = body

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
