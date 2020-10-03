extends Node

# I think we need to store all the music here and deal with signals
# so we don't have tons of overlapping stuff

const MIN_DB = -90.0
const MAX_DB = 0.0

var music_volume = 100  # percent

onready var layers = {
	'kick_2': $Kick2,
}

var muted = {
	'kick_2': true,
}


func play():
	for stream in layers.values():
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
