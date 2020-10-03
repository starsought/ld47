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

var spawned = {
	'cactus': false,
	'flower': false,
}

func add_plant(type):
	match type:
		'cactus':
			spawned['cactus'] = true
			$Music.unmute('kick_2')
			$Spawner/Cactus.hide()
		'flower':
			spawned['flower'] = true
			$Music.unmute('chord_1')
			$Spawner/Flower.hide()

func remove_plant(type):
	match type:
		'cactus':
			spawned['cactus'] = false
			$Music.mute('kick_2')
			$Spawner/Cactus.show()
		'flower':
			spawned['flower'] = false
			$Music.mute('chord_1')
			$Spawner/Flower.show()
