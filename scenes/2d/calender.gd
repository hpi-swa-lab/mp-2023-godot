extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	$ColorRect.color =  Color.DARK_GREEN if $ColorRect.color == Color.MEDIUM_VIOLET_RED else Color.MEDIUM_VIOLET_RED
