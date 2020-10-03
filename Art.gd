extends Sprite

# Better animation controls.

const FRAME_DURATION = 0.125

var base = 0
# which 16th notes are bounces
var bounce_frames = [
	0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0,
]

func animate(delta):
	var index = int(Timing.time/FRAME_DURATION) % 16
	frame = base + bounce_frames[index]
