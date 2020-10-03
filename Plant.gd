extends KinematicBody2D

export (String) var type = 'cactus'

onready var Main = $'..'  # big assumption here

var being_dragged = false
var drag_point_offset = Vector2()

func _ready():
	connect("input_event", self, "handle_input")

func handle_input(viewport, event, shape_index):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			being_dragged = true
			z_index = 1
			drag_point_offset = get_viewport().get_mouse_position() - position

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			if being_dragged:
				being_dragged = false
				z_index = 0
				drag_point_offset = Vector2()
				if destruction_zone(get_viewport().get_mouse_position()):
					Main.remove_plant(type)
					self.queue_free()

func _physics_process(delta):
	if being_dragged:
		var mouse = get_viewport().get_mouse_position()
		position = round_position(mouse - drag_point_offset)

func destruction_zone(mouse):
	return mouse.x > 256 or mouse.x < 0 or mouse.y > 512 or mouse.y < 0

func round_position(p):
	return (p/8).floor()*8
