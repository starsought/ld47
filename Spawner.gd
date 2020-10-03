extends Node2D

const CACTUS = preload("res://BigCactus.tscn")
const FLOWER = preload("res://SkinnyFlower.tscn")

onready var Main = $".."

func _ready():
	$Cactus/Box.connect("input_event", self, "handle_cactus")
	$Flower/Box.connect("input_event", self, "handle_flower")

func handle_cactus(viewport, event, shape_index):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			spawn_new_plant(CACTUS, $Cactus.global_position)

# How do we generalize this?
func handle_flower(viewport, event, shape_index):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			spawn_new_plant(FLOWER, $Flower.global_position)

func spawn_new_plant(scene, initial_position):
	var new_plant = scene.instance()
	new_plant.position = initial_position
	new_plant.being_dragged = true
	new_plant.drag_point_offset = get_viewport().get_mouse_position() - new_plant.position
	# probably need to keep these in a subnode
	# so they don't end up on top of everything else
	Main.add_child(new_plant)
