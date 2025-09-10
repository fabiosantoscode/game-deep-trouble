extends Node
class_name CameraFollowsSub

@onready var sub: Sub = $".."
#@onready var camera_2d: Camera2D = $Camera2D
var tilemap: TileMapLayer
var camera_2d: Camera2D

func _ready():
	if sub.owner == null: return # when we press F6 on the sub and not a level
	var level = sub.owner
	var tilemaps = level.find_children("", "TileMapLayer", true, false)
	if len(tilemaps) == 0: print("warning: TileMapLayer not found in the level")
	elif len(tilemaps) > 1: print("warning: Many TileMapLayer found in the level")
	else:
		_prepare_camera(tilemaps[0])
		get_viewport().size_changed.connect(func():
			_prepare_camera(tilemaps[0]))

func _process(_delta: float) -> void:
	if camera_2d is Camera2D and sub is Sub:
		camera_2d.global_position = sub.global_position

func _prepare_camera(t_map: TileMapLayer):
	var viewport_size = Vector2(get_viewport().size)

	var cell = t_map.tile_set.tile_size.x
	var rect = t_map.get_used_rect()
	if camera_2d == null:
		camera_2d = Camera2D.new()
		self.add_child(camera_2d)
		camera_2d.owner = self
		camera_2d.make_current()

	var limit_top = int(t_map.global_position.y) + rect.position.y * cell
	var limit_bottom = int(t_map.global_position.y) + rect.position.y * cell + rect.size.y * cell
	var limit_left = int(t_map.global_position.x) + rect.position.x * cell
	var limit_right = int(t_map.global_position.x) + rect.position.x * cell + rect.size.x * cell

	# Limit movement of the camera
	var level = sub.owner
	for bound: EndOfContent in level.find_children("", "EndOfContent", true, false):
		var bound_pos = bound.global_position
		match bound.direction:
			EndOfContent.Direction.TOP: limit_top = bound_pos.y
			EndOfContent.Direction.BOTTOM: limit_bottom = bound_pos.y
			EndOfContent.Direction.LEFT: limit_left = bound_pos.x
			EndOfContent.Direction.RIGHT: limit_right = bound_pos.x

	assert(limit_right > limit_left)
	assert(limit_bottom > limit_top)

	# we need more screen space
	var bounded_width = limit_right - limit_left
	if bounded_width < viewport_size.x:
		var remaining = (viewport_size.x - bounded_width) / 2.0
		limit_left = limit_left - remaining
		limit_right = limit_right + remaining

	var bounded_height = limit_bottom - limit_top
	if bounded_height < viewport_size.y:
		var remaining = (viewport_size.y - bounded_height) / 2.0
		limit_top = limit_top - remaining
		limit_bottom = limit_bottom + remaining

	camera_2d.limit_top = limit_top
	camera_2d.limit_bottom = limit_bottom
	camera_2d.limit_left = limit_left
	camera_2d.limit_right = limit_right

func get_only_or_warn(arr, warning):
	if len(arr) >= 1:
		if len(arr) > 1:
			print(warning)
		return arr[0]
	return null
