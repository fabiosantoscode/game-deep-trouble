extends Node2D
class_name SubMovement

@onready var sub: Sub = $".."

## Fingers don't key-travel instantly, bridge the gap
var last_input_duration = 0.2

## in joystick-position-squared-distance between rolling average and current
var movement_reversal_bubbles_threshold = 0.7 ** 2

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

func _ready() -> void:
	_ready_bubbles()

var _was_facing_left = false
func should_face_left(player_input: Vector2):
	if absf(player_input.x) > 0.1:
		_was_facing_left = player_input.x < 0
	return _was_facing_left
func should_face_updown(player_input: Vector2):
	return (
		1 if player_input.y < -0.3
		else -1 if player_input.y > 0.3
		else 0
	)

## Sub will call this in _process_physics
func move_sub(player_input: Vector2, delta: float):
	inertia = move_sub_inner(sub.has_rock != null, player_input, delta)
	sub.velocity = inertia
	sub.move_and_slide()

func move_sub_inner(is_carrying_rock: bool, player_input: Vector2, delta: float):
	var pushing_joystick = player_input.length_squared() > 0.1

	# Bridge over small finger rises
	var just_had_input = last_input_age < last_input_duration
	if pushing_joystick:
		last_input_age = 0.0
	else:
		last_input_age += delta # expire the last input

	_compute_bubbles(pushing_joystick, just_had_input, player_input)

	# NO MOVEMENT DESIRED
	if not pushing_joystick:
		return Utils.frame_independent_lerp(inertia, Vector2.ZERO, stop_speed, delta)

	# PLAYER WANTS TO MOVE

	# accel and speed are derived from whether we are carrying the rock
	var cur_speed = speed_with_rock if is_carrying_rock else speed

	# Calculate desired movement direction from input
	var desired_velocity = player_input * cur_speed

	# No interpolation when first accelerating
	if not just_had_input:
		return desired_velocity
	else:
		return Utils.frame_independent_lerp(inertia, desired_velocity, change_direction_speed, delta)

# Bubbles
# Bubbles are launched for 2 reasons:
# - the sub just started moving (we emit sub.movement_started)
# - the sub swiftly changed direction (we emit sub.movement_reversed)
var last_input_age = 0.0
var _movement_average
func _ready_bubbles():
	_movement_average = Utils.AverageVector.new(0.7)

func _compute_bubbles(pushing_joystick, just_had_input, player_input):
	if pushing_joystick and not just_had_input:
		sub.emit_movement_started(player_input, 1.0)
		_movement_average.reset()
	else:
		_movement_average.push(player_input)
		var reversal_rate = _reversal_detect(player_input)
		if reversal_rate > 0.0:
			sub.emit_movement_started(player_input, reversal_rate)
			_movement_average.reset()

func _reversal_detect(new_direction: Vector2):
	if _movement_average.is_filled() and new_direction.length_squared() > 0.1:
		var avg_vec: Vector2 = _movement_average.average()
		var diff = avg_vec.distance_squared_to(new_direction) - movement_reversal_bubbles_threshold
		if diff > 0.0:
			diff = avg_vec.normalized().distance_squared_to(new_direction)
			var max_joystick_sq_dist = 4.0 # 2.0 ** 2
			return inverse_lerp(0.0, max_joystick_sq_dist, diff)
	return 0.0

func get_inertia(): return inertia
func reset_inertia(): inertia = Vector2.ZERO
