extends Node2D
class_name SubMovement

## Lower values mean more slippery movement
var damping_factor = 0.01

## (pixels per second)
var speed = 110.0
var speed_with_rock = speed * 0.8

## Increase in speed (pixels per second per second)
var acceleration = 900.0

## Current speed, set into sub.velocity (CharacterBody3D.velocity)
var inertia = Vector2.ZERO

var speed_percent: float:
	get(): return inertia.length() / speed

var _was_facing_left = false

func should_face_left(player_input_normalized: Vector2):
	if player_input_normalized.x != 0.0:
		_was_facing_left = player_input_normalized.x < 0
	return _was_facing_left

func move_sub(sub: Sub, player_input_normalized: Vector2, delta: float):
	sub.velocity = move_sub_inner(sub.has_rock != null, player_input_normalized, delta)
	sub.move_and_slide()

## Sub will call this in _process_physics
func move_sub_inner(is_carrying_rock: bool, player_input_normalized: Vector2, delta: float):
	# accel and speed are derived from whether we are carrying the rock
	var cur_speed = speed_with_rock if is_carrying_rock else speed

	# Calculate desired movement direction from input
	var desired_velocity = player_input_normalized * cur_speed
	
	# Calculate the difference between current inertia and desired velocity
	var velocity_diff = desired_velocity - inertia
	
	# Apply acceleration to gradually change the inertia
	if velocity_diff.length_squared() > 0.001:
		var acceleration_vector = velocity_diff.normalized() * acceleration * delta
		# Don't overshoot the desired velocity
		if acceleration_vector.length() > velocity_diff.length():
			acceleration_vector = velocity_diff
		inertia += acceleration_vector
	else:
		inertia *= (1.0 - damping_factor * delta)

	return inertia

func reset_inertia(): inertia = Vector2.ZERO
