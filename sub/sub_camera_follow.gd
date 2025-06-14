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
	else: _prepare_camera(tilemaps[0])

func _process(delta: float) -> void:
	if camera_2d is Camera2D and sub is Sub:
		camera_2d.global_position = sub.global_position

func _prepare_camera(t_map: TileMapLayer):
	var cell = t_map.tile_set.tile_size.x
	var rect = t_map.get_used_rect()
	camera_2d = Camera2D.new()
	self.add_child(camera_2d)
	camera_2d.owner = self
	camera_2d.make_current()

	camera_2d.limit_top = int(t_map.global_position.y) + rect.position.y * cell
	camera_2d.limit_bottom = int(t_map.global_position.y) + rect.position.y * cell + rect.size.y * cell
	camera_2d.limit_left = int(t_map.global_position.x) + rect.position.x * cell
	camera_2d.limit_right = int(t_map.global_position.x) + rect.position.x * cell + rect.size.x * cell
