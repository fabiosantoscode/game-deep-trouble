extends Node2D
class_name SubInput 

## User input for the sub (WASD, arrow keys or controller). A compatible SubInput might be created if we want enemy subs with AIs
func get_movement_input() -> Vector2:
	var from_godot_input = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down"),
	)
	if from_godot_input.length_squared() > 0.05:
		return from_godot_input.normalized()
	else:
		return Vector2.ZERO
