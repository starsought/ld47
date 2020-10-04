extends Node

const BPM = 120.0
const FRAME_DURATION = BPM/60.0/16.0

var time = 0.0
func _process(delta):
	time += delta

func get_frame():
	return int(time/FRAME_DURATION)
