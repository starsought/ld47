extends KinematicBody2D

export (String) var type = 'cactus'

const OVERLAY_CLEAR = Color(1.0, 1.0, 1.0)
const OVERLAY_DELETE = Color(1.0, 0.0, 0.0)
const OVERLAY_GRAB = Color(0.9, 0.9, 0.9)

var frame = 0
var track = 'kick_2'

onready var Main = $'..'  # big assumption here

var being_dragged = false
var drag_point_offset = Vector2()

var plant_type_data = {}

# we could just do the same collision for now
func register_plant_type(type_id, frame, track, bounce_frames):
	plant_type_data[type_id] = {}
	plant_type_data[type_id]['frame'] = frame
	plant_type_data[type_id]['track'] = track
	plant_type_data[type_id]['bounce'] = bounce_frames
	

func apply_type(t):
	type = t
	var type_data = plant_type_data[type]
	frame = type_data['frame']
	$Art.frame = frame
	$Art.base = frame
	for f in type_data['bounce']:
		$Art.bounce_frames[f] = 1
	track = type_data['track']

func _ready():
	connect("input_event", self, "handle_input")
	register_plant_type('cactus', 0, 'kick'   , [10, 13, 15])
	register_plant_type('flower', 2, 'shaker' , [0, 2, 4, 6, 8, 10, 12, 14])
	register_plant_type('borb'  , 4, 'cowbell', [0, 6])
	register_plant_type('snake' , 6, 'ding', [0, 1, 2, 3, 8, 9, 10, 11])
	register_plant_type('herbs' , 8, 'chord', [0, 1, 2, 3, 14])
	$Plink.volume_db = -12.0

func _process(delta):
	$Art.animate(delta)

func handle_input(viewport, event, shape_index):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			being_dragged = true
			z_index = 1
			drag_point_offset = get_viewport().get_mouse_position() - position
			$Plink.play()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			if being_dragged:
				being_dragged = false
				z_index = 0
				drag_point_offset = Vector2()
				$Plink.play()
				if touching_destruction_zone():
					remove_from_arrangement()
					self.queue_free()

func _physics_process(delta):
	if being_dragged:
		var mouse = get_viewport().get_mouse_position()
		position = round_position(mouse - drag_point_offset)
#		position.y = 192 - 24  # not sure if I like this or not
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
