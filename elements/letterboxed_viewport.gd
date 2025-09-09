extends Node2D
class_name LetterboxedViewport

# 320x240 at time of writing, will be scaled up.
@onready var viewport_size = Vector2(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height")
)

@onready var sub_viewport_container: SubViewportContainer = $Parent/SubViewportContainer
@onready var inner_viewport: SubViewport = $Parent/SubViewportContainer/LetterboxInner
@onready var parent: Node2D = $Parent

func _ready():
	inner_viewport.size = Vector2i(viewport_size)
	get_window().size_changed.connect(_layout)
	_layout()

func _layout():
	var window_size = Vector2(get_window().size)

	var scale_needed = window_size / viewport_size
	var scale_factor = min(scale_needed.x, scale_needed.y)

	# round down to closest integer
	scale_factor = maxf(1, floori(scale_factor))

	var size_after_scale = scale_factor * viewport_size
	var letterbox_size = window_size - size_after_scale

	parent.scale = scale_factor * Vector2.ONE
	self.position = letterbox_size / 2.0
