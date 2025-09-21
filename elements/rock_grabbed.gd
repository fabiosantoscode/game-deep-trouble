extends Area2D
class_name RockGrabbed

const ROCK_GRABBED = preload("res://elements/rock_grabbed.tscn")
var sub: Sub
@export var stealth_modulate = Color.WHITE

static func create_grabbed_rock(sub_: Sub, pos: Vector2):
	var rock = ROCK_GRABBED.instantiate()
	rock.sub = sub_
	return Utils.spawn(sub_, rock, pos)

func _ready() -> void:
	if sub != null:
		sub.stealth_changed.connect(func():
			self.modulate = stealth_modulate if sub.is_stealthy else Color.WHITE)
