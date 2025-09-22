extends Node2D

@onready var large_title_x = floori($TitleLarge.size.x)
static var large_font_size = 21
static var small_font_size = 14
static var max_leftover_width = -4 # I am wider than the text because the "." in the title is thin

# Make sure we fit onscreen haha
func _ready() -> void:
	get_viewport().size_changed.connect(_layout)
	_layout.call_deferred()

func _layout():
	var vp = get_viewport()
	var size_diff = vp.size.x - large_title_x

	var is_small = size_diff < max_leftover_width

	$TitleLarge.visible = not is_small
	$SubtitleLarge.visible = not is_small
	$TitleSmall.visible = is_small
	$SubtitleSmall.visible = is_small
