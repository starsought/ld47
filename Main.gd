extends Node

const Plant = preload("res://Plant.tscn")

func _ready():
	$OptionButton.connect("button_down", self, "toggle_options")
	$Options/Music/Slider.connect("value_changed", $Music, "set_music_volume")
	$Music.play()

func _process(delta):
	pass

func toggle_options():
	$Options.visible = not $Options.visible
	if $Options.visible:
		$OptionButton.text = "Back"
	else:
		$OptionButton.text = "Options"

func add_plant_to_arrangement(plant):
	$Music.unmute(plant.track)
	$Spawner.disable_spawner(plant.type)

func move_plant_within_arrangement(plant):
	pass

func remove_plant_from_arrangement(plant):
	$Music.mute(plant.track)
	$Spawner.enable_spawner(plant.type)
