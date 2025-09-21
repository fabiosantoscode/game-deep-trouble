extends Area2D
class_name Rock

@onready var sprite = $Sprite

func become_grabbed(sub: Sub) -> RockGrabbed:
	var new_rock = RockGrabbed.create_grabbed_rock(sub, self.global_position)

	# Ensure the rock doesn't cover the sub, when grabbed.
	new_rock.global_position.y = sub.global_position.y + Sub.y_distance_to_rock

	self.queue_free()
	return new_rock
