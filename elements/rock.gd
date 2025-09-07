extends Area2D
class_name Rock

@onready var sprite = $Sprite

const ROCK = preload("res://elements/rock.tscn")
var was_just_spawned = true

func _ready():
	await get_tree().physics_frame
	await get_tree().physics_frame
	was_just_spawned = false

func become_grabbed(sub: Sub) -> RockGrabbed:
	var pos = self.sprite.global_position
	var new_rock = RockGrabbed.create_grabbed_rock(sub)
	sub.add_child(new_rock)
	new_rock.owner = sub
	new_rock.global_position = pos

	# Ensure the rock doesn't cover the sub, when grabbed.
	new_rock.global_position.y = sub.global_position.y + Sub.y_distance_to_rock

	self.queue_free()
	return new_rock

static func create_rock(parent: Node2D, pos: Vector2):
	var r = ROCK.instantiate()
	parent.add_child(r)
	r.owner = parent
	r.global_position = pos
	return r
