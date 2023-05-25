extends StaticBody3D


signal on_pointer_entered
signal on_pointer_exited


# Called when a user clicks on the cube using the pointer
func pointer_entered():
	# Randomize the color
	$Node3D.show()
	on_pointer_entered.emit()


func pointer_exited():
	# Randomize the color
	$Node3D.hide()
	on_pointer_exited.emit()
