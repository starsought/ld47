extends Control


func _ready():
#	show()
	$Timer.connect("timeout", self, "hide")

func _input(event):
	if visible:
		if event is InputEventKey:
			hide()
		elif event is InputEventMouseButton:
			hide()
		elif event is InputEventJoypadButton:
			hide()
