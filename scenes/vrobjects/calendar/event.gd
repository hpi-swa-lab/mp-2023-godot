extends TextBox

signal on_handle_pick_up

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	on_handle_pick_up.connect(on_picked_up)

func on_picked_up():
	if get_parent().has_method("is_day"):
		var p = get_parent()
		p.remove_child(self)
		p.get_parent().add_child(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
