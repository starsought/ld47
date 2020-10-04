extends Control


func _ready():
	show()
	$Logo.show()
	$Title.hide()
	$Timer.connect("timeout", self, "hide_next")

func hide_next():
	if $Logo.visible:
		$Logo.hide()
		$Title.show()
		$Title.show()
		$Timer.start(2.0)
	else:
		$Title.hide()
		hide()

func _input(event):
	pass  # actually no skipping I worked very hard on these
#	if visible:
#		if event is InputEventKey and event.pressed:
#			hide_next()
#		elif event is InputEventMouseButton and event.pressed:
#			hide_next()
#		elif event is InputEventJoypadButton and event.pressed:
#			hide_next()
