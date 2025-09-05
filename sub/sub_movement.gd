extends Node2D
class_name SubMovement

@onready var sub: Sub = $".."

## Fingers don't key-travel instantly, bridge the gap
var last_input_duration = 0.2
var last_input_age = 0.0

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
	_ready_reversal()

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
		last_input_age += delta # expire the last input
		inertia = Utils.frame_independent_lerp(inertia, Vector2.ZERO, stop_speed, delta)
		return inertia

	var just_had_input = last_input_age < last_input_duration
	last_input_age = 0.0

	# PLAYER WANTS TO MOVE

	# accel and speed are derived from whether we are carrying the rock
	var cur_speed = speed_with_rock if is_carrying_rock else speed

	# Calculate desired movement direction from input
	var desired_velocity = player_input * cur_speed

	# No interpolation when first accelerating
	if not just_had_input:
		inertia = desired_velocity
		sub.movement_started.emit(player_input)
		_reversal_reset()
	else:
		inertia = Utils.frame_independent_lerp(inertia, desired_velocity, change_direction_speed, delta)
		_reversal_detect(player_input)

	return inertia

# MOVEMENT REVERSAL
# When sonic stops and we press the opposite direction, he screeches to a halt
# The sub will emit some bubbles
var _movement_average
func _ready_reversal():
	_movement_average = Utils.AverageVector.new(0.4)

func _reversal_detect(new_direction: Vector2):
	_movement_average.push(new_direction)
	if _movement_average.is_filled() and new_direction.length_squared() > 0.1:
		var avg_vec: Vector2 = _movement_average.average()
		if avg_vec.distance_squared_to(new_direction) > 0.8:
			sub.movement_reversed.emit(new_direction)
			_movement_average.reset()

func _reversal_reset():
	_movement_average.reset()

func get_inertia(): return inertia
func reset_inertia(): inertia = Vector2.ZERO
