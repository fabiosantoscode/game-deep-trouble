extends Node2D
class_name SubInput 

var last_movement_input = Vector2.ZERO

## User input for the sub (WASD, arrow keys or controller).
## Enemy subs will use AI to provide movement
func get_movement_input(sub: Sub) -> Vector2:
	last_movement_input = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down"),
	)
	if last_movement_input.length_squared() > 0.05:
		last_movement_input = last_movement_input.limit_length(1.0)
	else:
		last_movement_input = Vector2.ZERO
	return last_movement_input

func _ai_stuff():
	return Vector2.RIGHT
