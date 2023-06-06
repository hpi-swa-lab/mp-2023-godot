class_name PanelManager
extends Node3D

var min_angle_between_panels = 1.4

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func angle_changed(angle, previous_angle, panel: AppPanel):
	var panel_index = get_children().find(panel)
	if panel_index > 0:
		var previous_panel = get_children()[panel_index-1]
		#L.log("Previous panel angle " + str(previous_panel._angle_on_circle) + str(" this angle: " + str(angle) + " prev angle " + str(previous_angle)))
		if abs(previous_panel._angle_on_circle - angle) < min_angle_between_panels:
			var min_angle = previous_panel._angle_on_circle + min_angle_between_panels * -1 *  sign(previous_panel.angle_on_circle - angle) 
			panel._set_angle(min_angle)
			return false
		else:
			return true # Angle change valid
	else:
		return true
