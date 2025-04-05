extends Area2D
class_name RockGrabbed

const ROCK_GRABBED = preload("res://elements/rock_grabbed.tscn")

static func create_grabbed_rock():
	return ROCK_GRABBED.instantiate()

func become_dropped_rock(sub: Sub):
	self.queue_free()
	# I don't know how this works exactly, but .owner is the editor scene that
	# Sub was placed in so it should be a non-moving object at (0, 0)
	var level_probably = sub.owner
	RockDropped.create_dropped_rock(sub, level_probably, self.global_position)
