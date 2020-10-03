extends Node

const Plant = preload("res://Plant.tscn")

func _ready():
	$OptionButton.connect("button_down", self, "toggle_options")

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_options()

func toggle_options():
	$Options.visible = not $Options.visible
	if $Options.visible:
		$OptionButton.text = "Back"
	else:
		$OptionButton.text = "Options"

# Can you spawn multiples of the same plant?
# What does it do to the music?
# Obviously we're not going to play duplicate tracks, right?
# Or could we?
pass
