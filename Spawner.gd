extends Node2D

const PLANT = preload("res://Plant.tscn")
const OVERLAY_LOCKED = Color(0.5, 0.5, 0.5)
const OVERLAY_AFFORDABLE = Color(0.75, 0.75, 0.75)
const OVERLAY_UNLOCKED = Color(1, 1, 1)

onready var Main = $".."
onready var spawn_nodes = {
	'sprout': $P0,
	'small_herbs': $P1,
	'big_herbs': $P2,
	'ivy': $P3,
	'cactus': $P4,
	'succulent': $P5,
	'willow': $P6,
	'bonsai': $P7,
	'overgrown_planter': $P8,
}

var store = {
	'sprout': 0,
	'small_herbs': 100,
	'big_herbs': 5000,
	'ivy': 2500,
	'cactus': 250,
	'succulent': 1500,
	'willow': 100,
	'bonsai': 750,
	'overgrown_planter': 200,
}

func _ready():
	$P0/Box.connect("input_event", self, "handle", ["sprout"])
	$P1/Box.connect("input_event", self, "handle", ["small_herbs"])
	$P2/Box.connect("input_event", self, "handle", ["big_herbs"])
	$P3/Box.connect("input_event", self, "handle", ["ivy"])
	$P4/Box.connect("input_event", self, "handle", ["cactus"])
	$P5/Box.connect("input_event", self, "handle", ["succulent"])
	$P6/Box.connect("input_event", self, "handle", ["willow"])
	$P7/Box.connect("input_event", self, "handle", ["bonsai"])
	$P8/Box.connect("input_event", self, "handle", ["overgrown_planter"])
	update_store_display()

func handle(v, input, i, type):
	if input is InputEventMouseButton:
		if input.button_index == BUTTON_LEFT and input.pressed:
			if unlocked(type):
				spawn_new_plant(type)
			else:
				if Main.money >= store[type]:
					Main.money -= store[type]
					purchase(type)
					spawn_new_plant(type)
				else:
					pass  # play a sound or something?

func spawn_new_plant(type):
	var scene = PLANT
	var new_plant = scene.instance()
	new_plant.type = type
	new_plant.position = spawn_nodes[type].global_position
	new_plant.being_dragged = true
	new_plant.drag_point_offset = get_viewport().get_mouse_position() - new_plant.position
	new_plant.plink()
	Main.get_node("Plants").add_child(new_plant)  # triggers _ready()
	Main.add_plant_to_arrangement(new_plant)
	
func disable_spawner(type):
	spawn_nodes[type].hide()

func enable_spawner(type):
	spawn_nodes[type].show()



func update_store_display():
	for type in store.keys():
		var cost = store[type]
		var node = spawn_nodes[type]
		if cost > 0:
			if cost <= Main.money:
				node.self_modulate = OVERLAY_AFFORDABLE
				node.get_node('Lock').modulate = OVERLAY_UNLOCKED
			else:
				node.self_modulate = OVERLAY_LOCKED
				node.get_node('Lock').modulate = OVERLAY_LOCKED
			node.get_node('Lock').show()
			node.get_node('Lock/Price').text = str(cost)
		else:
			node.self_modulate = OVERLAY_UNLOCKED
			node.get_node('Lock').hide()
	if Main.money >= 1000000:
		$Money.text = "MAX"
	else:
		$Money.text = str(Main.money)

func unlocked(type):
	return store[type] == 0

func purchase(type):
	store[type] = 0
	update_store_display()
