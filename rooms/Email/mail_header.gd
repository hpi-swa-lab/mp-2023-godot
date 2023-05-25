extends Node3D

@export_multiline var header_text = ""

func _ready():
	var label : Label = $SubViewport/GUI/Panel/Label
	label.text = header_text


func _on_mail_picked_up(pickable):
	$Quad.show()


func _on_mail_dropped(pickable):
	$Quad.hide()
