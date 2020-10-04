extends Node

const Plant = preload("res://Plant.tscn")

func _ready():
	$OptionButton.connect("button_down", self, "toggle_options")
	$Options/Music/Slider.connect("value_changed", $Music, "set_music_volume")
	$Music.play()

var frame_count = 0
func _process(delta):
	if Timing.get_frame() > frame_count:
		for type in spawned.keys():
			if spawned[type]:
				var cycle = money_cycles[type]
				var index = Timing.get_frame() % len(cycle)
				money += cycle[index]
		$Spawner/Money.text = str(money)
		frame_count = Timing.get_frame()


func toggle_options():
	$Options.visible = not $Options.visible
	if $Options.visible:
		$OptionButton.text = "Back"
		$Spawner.hide()
	else:
		$OptionButton.text = "Options"
		$Spawner.show()

var money = 100
var money_cycles = {
	'sprout': [1,0,0,0],
	'small_herbs': [1],
	'big_herbs': [1],
	'ivy': [1],
	'cactus': [1],
	'succulent': [1],
	'willow': [1],
	'bonsai': [1],
	'overgrown_planter': [1],
}
var spawned = {
	'sprout': false,
	'small_herbs': false,
	'big_herbs': false,
	'ivy': false,
	'cactus': false,
	'succulent': false,
	'willow': false,
	'bonsai': false,
	'overgrown_planter': false,
}

func add_plant_to_arrangement(plant):
	$Music.unmute(plant.get_track())
	$Spawner.disable_spawner(plant.type)
	spawned[plant.type] = true

func move_plant_within_arrangement(plant):
	pass

func remove_plant_from_arrangement(plant):
	$Music.mute(plant.get_track())
	$Spawner.enable_spawner(plant.type)
	spawned[plant.type] = false
