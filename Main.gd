extends Node

const Plant = preload("res://Plant.tscn")

func _ready():
	$OptionButton.connect("button_down", self, "toggle_options")
	$Options/Music/Slider.connect("value_changed", $Music, "set_music_volume")
	$Music.play()
	$Metronome.play()

var frame_count = 0
func _process(delta):
	if Timing.get_frame() > frame_count:
		for type in spawned.keys():
			if spawned[type]:
				var cycle = get_money_cycle(type)
				var index = Timing.get_frame() % len(cycle)
				money += cycle[index]
		$Spawner/Money.text = str(money)
		frame_count = Timing.get_frame()
	$Spawner.update_store_display()


func toggle_options():
	$Options.visible = not $Options.visible
	if $Options.visible:
		$OptionButton.text = "Back"
		$Spawner.hide()
	else:
		$OptionButton.text = "Options"
		$Spawner.show()

var money = 75
# this is several layers of stupid
func get_money_cycle(type):
	match type:
		# 16 per measure
		'sprout': return [1]
		# 40 per measure
		'small_herbs': return [10,0,0,0]
		# oh boy I'm not counting that
		'big_herbs': return [
			250,250,250,250, 25,0,0,0, 25,0,25,25, 25,25,0,0,
			1000,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,100,0,
			500,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			]
		# 200 per two measures / 100 per measure
		'ivy': return [
			0,0,0,0, 50,0,0,0, 0,0,0,0, 0,0,0,0,
			0,0,0,0, 50,0,0,50, 0,50,0,0, 0,0,0,0,
			]
		# 205 per two measures / ~100 per measure
		'cactus': return [
			50,0,0,0, 0,0,0,0, 0,0,25,0, 0,25,0,5,
			50,0,0,0, 0,0,0,0, 0,0,25,0, 0,25,0,0,
			]
		# nope
		'succulent': return [
			1000,0,0,0, 10,0,0,0, 10,0,0,5, 0,5,0,5, 
			10,0,0,0, 10,0,0,0, 10,0,0,0, 10,0,0,0,
			10,0,0,0, 10,0,0,0, 10,0,0,5, 0,5,0,5, 
			10,0,0,0, 10,0,0,0, 10,0,0,0, 10,0,1,1,
			100,0,0,0, 10,0,0,0, 10,0,0,5, 0,5,0,5, 
			10,0,0,0, 10,0,0,0, 10,0,0,0, 10,1,1,1,
			100,0,0,0, 10,0,0,0, 10,0,0,5, 0,5,0,5, 
			10,0,0,0, 10,0,0,0, 10,0,0,5, 0,5,0,5, 
			]
		# 30 per measure
		'willow': return [
			15,0,0,0, 0,0,15,0, 0,0,0,0, 0,0,0,0,
			]
		# 225 per four measures
		'bonsai': return [
			0,0,0,0, 0,0,0,0, 25,0,0,25, 0,0,25,0,
			0,0,0,0, 0,0,0,0, 25,0,0,25, 0,0,25,0,
			0,0,0,0, 0,0,0,0, 25,0,0,25, 0,0,25,0,
			0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 
			]
		# thank god an easy one
		# 200 per four measures / 50 a measure
		'overgrown_planter': return [
			200,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 
			0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			]

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

var game_complete = false
func add_plant_to_arrangement(plant):
	$Music.unmute(plant.get_track())
	$Spawner.disable_spawner(plant.type)
	spawned[plant.type] = true

	var all_spawned = true
	for type in spawned.keys():
		if not spawned[type]:
			all_spawned = false
			break
	if all_spawned and not game_complete:
		game_complete = true
		money = 1000000
		var plants = $Plants.get_children()
		var one_plant = plants[randi()%len(plants)]
		one_plant.say("thanks for playing!", 8.0)

func move_plant_within_arrangement(plant):
	pass

func remove_plant_from_arrangement(plant):
	$Music.mute(plant.get_track())
	$Spawner.enable_spawner(plant.type)
	spawned[plant.type] = false
