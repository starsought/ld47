extends Sprite

var base = 0
var animation_cycle = [0]

func set_sprite_data(b, cycle):
	base = b
	frame = b
	animation_cycle = cycle

func animate(delta):
	var index = Timing.get_frame() % len(animation_cycle)
	frame = base + animation_cycle[index]
