extends KinematicBody2D

const OVERLAY_CLEAR = Color(1.0, 1.0, 1.0)
const OVERLAY_DELETE = Color(1.0, 0.0, 0.0)
const OVERLAY_GRAB = Color(0.8, 0.8, 0.8)
# todo: hover

onready var Main = $'..'  # big assumption here


var type = 'cactus'

var being_dragged = false
var drag_point_offset = Vector2()
var said_hello = false

# Plant Type Data
func get_track():
	match type:
		'sprout': return 'shaker'
		'small_herbs': return 'shaker'
		'big_herbs': return 'chord'
		'ivy': return 'cowbell'
		'cactus': return 'bass'
		'succulent': return 'kick'
		'willow': return 'clap'
		'bonsai': return 'kick'
		'overgrown_planter': return 'kick'

func get_base_frame():
	match type:
		'sprout': return 0
		'small_herbs': return 1
		'big_herbs': return 2
		'ivy': return 3
		'cactus': return 4
		'succulent': return 5
		'willow': return 6
		'bonsai': return 7
		'overgrown_planter': return 8

func get_animation_cycle():
	match type:
		'sprout': return [0]
		'small_herbs': return [0]
		'big_herbs': return [0]
		'ivy': return [0]
		'cactus': return [1,0,0,0, 0,0,0,0, 0,0,1,0, 0,1,0,1]
		'succulent': return [0]
		'willow': return [0]
		'bonsai': return [0]
		'overgrown_planter': return [0]



func _ready():
	connect("input_event", self, "handle_input")
	$Plink.volume_db = -12.0  # todo: sfx volume control
	$Art.set_sprite_data(get_base_frame(), get_animation_cycle())

func _process(delta):
	$Art.animate(delta)

func handle_input(viewport, event, shape_index):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			being_dragged = true
			z_index = 1
			drag_point_offset = get_viewport().get_mouse_position() - position
			hide_text_bubble()
			plink()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			if being_dragged:
				being_dragged = false
				z_index = 0
				drag_point_offset = Vector2()
				if not said_hello:
					say('hello')
					said_hello = true
				plink()
				if touching_destruction_zone():
					remove_from_arrangement()
					self.queue_free()

func _physics_process(delta):
	if being_dragged:
		var mouse = get_viewport().get_mouse_position()
		position = round_position(mouse - drag_point_offset)

		if touching_destruction_zone():
			modulate = OVERLAY_DELETE
		else:
			modulate = OVERLAY_GRAB
	else:
		modulate = OVERLAY_CLEAR

func touching_destruction_zone():
	var x = $Collision.shape.extents.x * scale.x
	var y = $Collision.shape.extents.y * scale.y
	var p = global_position
	return p.x + x > 256 or p.x - x < 0 or p.y + y > 256 or p.y - y < 0

func round_position(p):
	return (p/8).floor()*8

func add_to_arrangement():
	Main.add_plant_to_arrangement(self)

func remove_from_arrangement():
	Main.remove_plant_from_arrangement(self)



func say(text):
	$Bubble.show()
	$Bubble/Text.text = text
	$Bubble/Timer.connect("timeout", self, 'hide_text_bubble')
	$Bubble/Timer.start(2.0)

func hide_text_bubble():
	$Bubble.hide()

func plink():
	$Plink.play()
