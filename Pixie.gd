extends Sprite

# Better animation controls.

const FRAME_DURATION = 0.1

var time = 0.0
var animations = {
	'example': [0, 1, 2, -1],
	'walk_d': [10, 11, 12, 13, 14, 15, 16, 17, 18, 19],
	'walk_r': [-20, -21, -22, -23, -24, -25, -26, -27, -28, -29],
}
var active_animation = 'example'

func start_new_animation(a):
	active_animation = a
	time = 0.0

func animate(delta):
	time += delta
	var frame_list = animations[active_animation]
	var index = int(time/FRAME_DURATION) % len(frame_list)
	var n = frame_list[index]
	if n < 0:  # -1 indicates frame 1 but flipped
		n = abs(n)
		flip_h = true
	else:
		flip_h = false
	frame = n
