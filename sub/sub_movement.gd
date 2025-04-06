extends Node2D
class_name SubMovement

## Lower values mean more slippery movement
var damping_factor = 0.01

## (pixels per second)
var speed = 100.0
var speed_with_rock = speed * 0.7

## Increase in speed (pixels per second per second)
var acceleration = 180.0

## Current speed, set into sub.velocity (CharacterBody3D.velocity)
var _inertia = Vector2.ZERO

var stagger_velocity = 20.0
var pre_stagger_max_speed = 10.0

var _was_facing_left = false

func should_face_left(player_input_normalized: Vector2):
	if player_input_normalized.x != 0.0:
		_was_facing_left = player_input_normalized.x < 0
	return _was_facing_left

func move_sub(sub: Sub, player_input_normalized: Vector2, delta: float):
	var new_velocity = move_sub_inner(sub.has_rock != null, player_input_normalized, delta)

	sub.velocity = new_velocity
	var did_collide = sub.move_and_slide()

	if did_collide:
		var coll = sub.get_last_slide_collision()
		# clamp inertia to a max length
		_inertia = _inertia.limit_length(pre_stagger_max_speed)
		_inertia += coll.get_normal() * stagger_velocity

## Sub will call this in _process_physics
func move_sub_inner(is_carrying_rock: bool, player_input_normalized: Vector2, delta: float):
	# accel and speed are derived from whether we are carrying the rock
	var cur_speed = speed_with_rock if is_carrying_rock else speed

	# Calculate desired movement direction from input
	var desired_velocity = player_input_normalized * cur_speed
	
	# Calculate the difference between current inertia and desired velocity
	var velocity_diff = desired_velocity - _inertia
	
	# Apply acceleration to gradually change the inertia
	if velocity_diff.length_squared() > 0.001:
		var acceleration_vector = velocity_diff.normalized() * acceleration * delta
		# Don't overshoot the desired velocity
		if acceleration_vector.length() > velocity_diff.length():
			acceleration_vector = velocity_diff
		_inertia += acceleration_vector
	else:
		_inertia *= (1.0 - damping_factor * delta)

	return _inertia

func reset_inertia(): _inertia = Vector2.ZERO
