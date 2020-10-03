extends KinematicBody2D

# plant selector
# also have to deal with large vs small hitboxes later on

var being_dragged = false
var drag_point_offset = Vector2()

func _ready():
	connect("input_event", self, "handle_input")

func handle_input(viewport, event, shape_index):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			being_dragged = true
			drag_point_offset = get_viewport().get_mouse_position() - position
		if event.button_index == BUTTON_RIGHT and event.pressed:
			# temp: right click removes plant
			# todo: drag plant to trash can?
			self.queue_free()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			being_dragged = false
			drag_point_offset = Vector2()

func _physics_process(delta):
	if being_dragged:
		var mouse = get_viewport().get_mouse_position()
		var movement = (mouse - drag_point_offset) - position
		move_and_slide(movement/delta)
