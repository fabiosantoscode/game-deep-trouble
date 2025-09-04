extends Node2D
class_name SubInput 

var last_input = Vector2.ZERO

## User input for the sub (WASD, arrow keys or controller).
func get_movement_input(sub: Sub) -> Vector2:
	last_input = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down"),
	) + VirtualJoystick.virtual_joystick_position

	if last_input.length_squared() > 0.05:
		return last_input.limit_length(1.0)
	else:
		return Vector2.ZERO
