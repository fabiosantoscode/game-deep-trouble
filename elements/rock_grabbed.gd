extends Area2D
class_name RockGrabbed

const ROCK_GRABBED = preload("res://elements/rock_grabbed.tscn")
var sub: Sub
@export var stealth_modulate = Color.WHITE

static func create_grabbed_rock(sub: Sub):
	var rock = ROCK_GRABBED.instantiate()
	rock.sub = sub
	return rock

func _ready() -> void:
	if sub != null:
		sub.stealth_changed.connect(func(is_stealthy):
			self.modulate = stealth_modulate if is_stealthy else Color.WHITE)

func become_dropped_rock(sub: Sub):
	self.queue_free()
	# I don't know how this works exactly, but .owner is the editor scene that
	# Sub was placed in so it should be a non-moving object at (0, 0)
	var level_probably = sub.owner
	RockDropped.create_dropped_rock(sub, level_probably, self.global_position)
