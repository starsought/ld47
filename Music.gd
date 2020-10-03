extends Node

# I think we need to store all the music here and deal with signals
# so we don't have tons of overlapping stuff

var time = 0.0

const MIN_DB = -90.0
const MAX_DB = 0.0

var music_volume = 1.0

onready var layers = {
	'kick': $Kick,
	'cowbell': $Cowbell,
	'shaker': $Shaker,
	'chord': $Chord,
	'ding': $Ding,
	'bass': $Bass,
	'clap': $Clap,
}

var muted = {
	'kick': true,
	'cowbell': true,
	'shaker': true,
	'chord': true,
	'ding': true,
	'bass': true,
	'clap': true,
}



func play():
	for stream in layers.values():
		stream.volume_db = MIN_DB
		stream.play()

func mute(l):
	muted[l] = true
	var stream = layers[l]
	stream.volume_db = MIN_DB

func unmute(l):
	muted[l] = false
	var stream = layers[l]
	stream.volume_db = db(music_volume)

func toggle(l):
	if muted[l]:
		unmute(l)
	else:
		mute(l)

func set_music_volume(pc):
	music_volume = min(100, max(0, pc))/100.0  # from [0, 100] to [0.0, 1.0]
	for l in layers.keys():
		if not muted[l]:
			layers[l].volume_db = db(music_volume)

# convert volume percentage to decibels
func db(percent):  # percent should be in [0.0, 1.0]
	return lerp(MIN_DB, MAX_DB, pow(percent, 0.25))

func _process(delta):
	time += delta
