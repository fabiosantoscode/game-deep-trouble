extends Node
class_name CameraFollowsSub

@onready var sub: Sub = $".."
var camera: Camera2D
var tilemap: TileMapLayer

func _ready():
	var level = sub.owner
	var tilemaps = level.find_children("", "TileMapLayer", true, false)
	if len(tilemaps) == 0: print("warning: TileMapLayer not found in the level")
	elif len(tilemaps) > 1: print("warning: Many TileMapLayer found in the level")
	else: _prepare_camera(tilemaps[0])

func _prepare_camera(t_map):
	tilemap = t_map
	camera = Camera2D.new()
	pass
