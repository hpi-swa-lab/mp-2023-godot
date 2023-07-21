extends Button


func _ready():
	connect("button_down", func(): disabled = true)
