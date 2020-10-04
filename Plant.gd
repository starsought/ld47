extends KinematicBody2D

const OVERLAY_CLEAR = Color(1.0, 1.0, 1.0)
const OVERLAY_DELETE = Color(1.0, 0.0, 0.0)
const OVERLAY_GRAB = Color(0.8, 0.8, 0.8)
# todo: hover

onready var Main = $'../..'  # big assumption here


var type = 'cactus'

var being_dragged = false
var drag_point_offset = Vector2()
var said_hello = false

var hello_messages = [
	'hello',
	'hello',
	'hi',
	'...',
	'oh hello',
	'hi there',
	'this is a jam',
	'i love this song',
	]

var second_placement_messages = [
	'welcome back',
	'here we go',
	'this is cool',
	'good spot',
	'love it here',
	'i love you',
]

# Plant Type Data
func get_track():
	match type:
		'sprout': return 'shaker'
		'small_herbs': return 'pedal'
		'big_herbs': return 'melody'
		'ivy': return 'snare'
		'cactus': return 'kick'
		'succulent': return 'bass'
		'willow': return 'cowbell'
		'bonsai': return 'harmony'
		'overgrown_planter': return 'chords'

func get_base_frame():
	match type:
		'sprout': return 0
		'small_herbs': return 2
		'big_herbs': return 4
		'ivy': return 6
		'cactus': return 8
		'succulent': return 10
		'willow': return 12
		'bonsai': return 14
		'overgrown_planter': return 16

func get_animation_cycle():
	match type:
		'sprout': return [0,1]
		'small_herbs': return [0,0,0,0, 1,1,1,1]
		'big_herbs': return [
			1,1,1,0, 1,1,1,0, 1,1,1,0, 1,1,1,0,
			1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,0,0,
			1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1, 
			0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			]
		'ivy': return [
			0,0,0,0, 1,0,0,0, 0,0,0,0, 0,0,0,0,
			0,0,0,0, 1,0,0,1, 0,1,0,0, 0,0,0,0,
			]
		'cactus': return [
			1,0,0,0, 0,0,0,0, 0,0,1,0, 0,1,0,1,
			1,0,0,0, 0,0,0,0, 0,0,1,0, 0,1,0,0,
			]
			# why did I do this
		'succulent': return [
			1,1,0,0, 1,1,0,0, 1,1,0,1, 0,1,0,1, 
			1,1,0,0, 1,1,0,0, 1,1,0,0, 1,1,0,0, 
			1,1,0,0, 1,1,0,0, 1,1,0,1, 0,1,0,1, 
			1,1,0,0, 1,1,0,0, 1,1,0,0, 1,1,1,1, 
			1,1,0,0, 1,1,0,0, 1,1,0,1, 0,1,0,1, 
			1,1,0,0, 1,1,0,0, 1,1,0,0, 1,1,0,0, 
			1,1,0,0, 1,1,0,0, 1,1,0,1, 0,1,0,1, 
			1,1,0,0, 1,1,0,0, 1,1,0,1, 0,1,0,1, 
			]
		'willow': return [
			1,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,
			]
		'bonsai': return [
			0,0,0,0, 0,0,0,0, 1,1,0,1, 0,0,1,1,
			1,1,1,1, 0,0,0,0, 1,1,0,1, 0,0,1,1,
			1,1,1,1, 0,0,0,0, 1,1,0,1, 0,0,1,1,
			1,1,1,1, 1,1,1,1, 1,1,1,1, 0,0,0,0,
			]
		'overgrown_planter': return [
			1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1, 
			1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1, 
			0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			]



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
			z_index = 2
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
#				if not said_hello:
#					say(hello_messages[randi()%len(hello_messages)], 1.0)
#					said_hello = true
#				else:
#					say(second_placement_messages[randi()%len(second_placement_messages)], 1.0)
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



func say(text, time):
	$Bubble.show()
	$Bubble/Text.text = text
	$Bubble/Timer.connect("timeout", self, 'hide_text_bubble')
	$Bubble/Timer.start(time)

func hide_text_bubble():
	$Bubble.hide()

func plink():
	$Plink.play()
