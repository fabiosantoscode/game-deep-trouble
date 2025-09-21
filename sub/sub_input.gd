extends Node2D
class_name SubInput

@onready var touch_input_panel: Panel = $TouchInputPanel
@onready var sub: Sub = $".."

var last_input = Vector2.ZERO
## scale joystick input, to accomodate older joysticks not going up to 1.0
const max_zone = 1.2
## When the finger is close to the sub, move more slowly.
const touch_input_slow_threshold_sq = 30.0 ** 2
const touch_input_stop_threshold_sq = 10.0 ** 2
const touch_input_slow_speed_ratio = 0.5

func _ready() -> void:
	_ready_touch_input()

## User input for the sub (WASD, arrow keys or controller).
func get_movement_input() -> Vector2:
	return (_get_joy_input() + _get_touch_input()).limit_length(1.0)

func _ready_touch_input():
	touch_input_panel.visible = true
	touch_input_panel.gui_input.connect(func(event: InputEvent):
		if event is InputEventMouseButton:
			_set_touch_pos(event.position, event.pressed)
		elif event is InputEventMouseMotion:
			_set_touch_pos(event.position)
		)

var _is_touching = false
var _finger_position = Vector2.ZERO
var _camera_position = null

func _get_touch_input():
	if not _is_touching: return Vector2.ZERO

	var touch_input = _get_touch_pos() - sub.global_position
	var touch_len = touch_input.length_squared()
	if touch_len < touch_input_stop_threshold_sq:
		return Vector2.ZERO
	elif touch_len < touch_input_slow_threshold_sq:
		# 0 is to touch_len = stop
		# 0.5 is to touch_len = touch_input_slow_threshold_sq
		var interpolated_ratio = remap(touch_len, touch_input_stop_threshold_sq, touch_input_slow_threshold_sq, touch_input_slow_speed_ratio, 1.0)
		return touch_input.limit_length(interpolated_ratio)
	else:
		return touch_input.limit_length(1.0)

func _set_touch_pos(touch_pos, is_pressed = _is_touching):
	_finger_position = touch_input_panel.global_position + touch_pos
	_is_touching = is_pressed
	
	var cam = get_viewport().get_camera_2d()
	if cam: _camera_position = Vector2(cam.get_screen_center_position())
	else: _camera_position = null

func _get_touch_pos():
	var camera_shift = Vector2.ZERO
	var cam = get_viewport().get_camera_2d()
	if _camera_position and cam != null:
		camera_shift = cam.get_screen_center_position() - _camera_position

	return _finger_position + camera_shift

func _get_joy_input():
	last_input = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down"),
	)

	if last_input.length_squared() > 0.05:
		return (last_input * max_zone).limit_length(1.0)
	else:
		return Vector2.ZERO
