extends Area2D
class_name Rock

@onready var sprite = $Sprite

const ROCK = preload("res://elements/rock.tscn")

func become_grabbed(sub: Sub) -> RockGrabbed:
	var pos = self.sprite.global_position
	var new_rock = RockGrabbed.create_grabbed_rock()
	sub.add_child(new_rock)
	new_rock.owner = sub
	new_rock.global_position = pos

	self.queue_free()
	return new_rock

static func create_rock(parent: Node2D, pos: Vector2):
	var r = ROCK.instantiate()
	parent.add_child(r)
	r.owner = parent
	r.global_position = pos
	return r
