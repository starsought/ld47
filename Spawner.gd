extends Node2D

const PLANT = preload("res://Plant.tscn")

onready var Main = $".."
onready var spawn_nodes = {
	'cactus': $Cactus,
	'flower': $Flower,
	'borb'  : $Borb,
	'snake' : $Snake,
	'herbs' : $Herbs,
}


func _ready():
	$Cactus/Box.connect("input_event", self, "handle", ["cactus"])
	$Flower/Box.connect("input_event", self, "handle", ["flower"])
	$Borb/Box.connect("input_event", self, "handle", ["borb"])
	$Snake/Box.connect("input_event", self, "handle", ["snake"])
	$Herbs/Box.connect("input_event", self, "handle", ["herbs"])

func handle(v, input, i, type):
	if input is InputEventMouseButton:
		if input.button_index == BUTTON_LEFT and input.pressed:
			spawn_new_plant(type)

func spawn_new_plant(type):
	var scene = PLANT
	var new_plant = scene.instance()
	Main.add_child(new_plant)  # triggers _ready()
	new_plant.apply_type(type)
	new_plant.position = spawn_nodes[type].global_position
	new_plant.being_dragged = true
	new_plant.drag_point_offset = get_viewport().get_mouse_position() - new_plant.position
	new_plant.get_node("Plink").play()
	Main.add_plant_to_arrangement(new_plant)
	
func disable_spawner(type):
	spawn_nodes[type].hide()

func enable_spawner(type):
	spawn_nodes[type].show()
