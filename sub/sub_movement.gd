extends Node2D
class_name SubMovement

## percentage towards 0m/s per second
var stop_speed = 10.0
var change_direction_speed = 20.0

## (pixels per second)
var speed = 110.0
var speed_with_rock = speed * 0.8

## Current speed, set into sub.velocity (CharacterBody3D.velocity)
var inertia = Vector2.ZERO

var speed_percent: float:
	get(): return inertia.length() / speed

var _was_facing_left = false
func should_face_left(player_input: Vector2):
	if absf(player_input.x) > 0.1:
		_was_facing_left = player_input.x < 0
	return _was_facing_left

## Sub will call this in _process_physics
func move_sub(sub: Sub, player_input: Vector2, delta: float):
	sub.velocity = move_sub_inner(sub.has_rock != null, player_input, delta)
	sub.move_and_slide()

var _no_input = true
func move_sub_inner(is_carrying_rock: bool, player_input: Vector2, delta: float):
	var no_input_before = _no_input
	_no_input = player_input.length_squared() < 0.1

	# NO MOVEMENT DESIRED
	if _no_input:
		inertia = frame_independent_lerp(inertia, Vector2.ZERO, stop_speed, delta)
		return inertia

	# PLAYER WANTS TO MOVE

	# accel and speed are derived from whether we are carrying the rock
	var cur_speed = speed_with_rock if is_carrying_rock else speed

	# Calculate desired movement direction from input
	var desired_velocity = player_input * cur_speed

	# No interpolation when first accelerating
	if no_input_before and speed_percent < 0.5:
		inertia = desired_velocity
	else:
		inertia = frame_independent_lerp(inertia, desired_velocity, change_direction_speed, delta)

	return inertia

func get_inertia(): return inertia
func reset_inertia(): inertia = Vector2.ZERO

static func frame_independent_lerp(from, to, amount: float, delta: float):
	var e = 2.718281828459045
	return lerp(from, to, 1 - pow(e, -amount * delta))
