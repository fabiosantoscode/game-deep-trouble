extends Node2D
class_name LetterboxedViewport

# 240x180 at time of writing. will be scaled up and re-oriented dynamically.
@onready var default_viewport = Vector2(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height")
)
@onready var viewport_small_measure = minf(default_viewport.x, default_viewport.y)

const max_aspect_ratio = 21.0 / 9.0
const min_aspect_ratio = 9.0 / 21.0

@onready var stretched_viewport: CanvasItem = $StretchedViewport
@onready var inner_viewport: SubViewport = $StretchedViewport/LetterboxInner

# remap input xy coordinates and put event into the inner viewport
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouse:
		var pos_01 = (event.global_position - self.position) / stretched_viewport.scale

		event.position = pos_01 * Vector2(inner_viewport.size)
		event.global_position = event.position

		inner_viewport.push_input(event, true)
	else:
		inner_viewport.push_input(event, true)

func _ready():
	get_window().size_changed.connect(_layout)
	_layout()

func _layout():
	var window_size = Vector2(get_window().size)
	var size_after_scale = _restrict_aspect_ratio(window_size)

	var scale_v = size_after_scale / viewport_small_measure
	var scale_factor = minf(scale_v.x, scale_v.y)
	var letterbox_size = window_size - size_after_scale

	inner_viewport.size = Vector2i(size_after_scale / scale_factor)
	stretched_viewport.scale = size_after_scale
	self.position = letterbox_size / 2.0

# When too wide (or tall), recompute the width (or height) to get
# the widest (or tallest) possible ratio
func _restrict_aspect_ratio(window_size: Vector2):
	var real_ratio = window_size.x / window_size.y

	if real_ratio < min_aspect_ratio: # too tall
		return Vector2(window_size.x, window_size.x / min_aspect_ratio)
	elif real_ratio > max_aspect_ratio: # too wide
		return Vector2(window_size.y * max_aspect_ratio, window_size.y)
	else:
		return window_size
