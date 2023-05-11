extends Node3D

@export_multiline var body_text = ""


func _ready():
	$Quad.hide()
	$SubViewport/GUI/Panel/RichTextLabel.clear()
	$SubViewport/GUI/Panel/RichTextLabel.add_text(body_text)


func _on_mail_picked_up(pickable):
	$Quad.show()


func _on_mail_dropped(pickable):
	$Quad.hide()
