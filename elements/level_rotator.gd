extends Node2D
class_name LevelRotator

@onready var level_container: Node = $LevelContainer

var level_scene_name_start = "res://levels/level"
var level_scene_name_end = ".tscn"
var current_level = 0
var level_count = 4

static func find_level_rotator(from_child: Node) -> LevelRotator:
	return from_child.find_parent("LevelRotator")

static func restart_level(from_child: Node):
	var level_rot = find_level_rotator(from_child)
	if level_rot != null:
		level_rot._start_level(level_rot.current_level)

static func next_level(from_child: Node):
	var level_rot = find_level_rotator(from_child)
	if level_rot != null:
		level_rot._start_level.call_deferred(level_rot.current_level + 1)

func _ready():
	_start_level(1)

func _start_level(level_num: int):
	for prev_level in level_container.get_children():
		level_container.remove_child(prev_level)
		prev_level.queue_free()

	current_level = level_num

	var level_file = level_scene_name_start + str(level_num) + level_scene_name_end
	var level = load(level_file).instantiate()
	level_container.add_child(level)
