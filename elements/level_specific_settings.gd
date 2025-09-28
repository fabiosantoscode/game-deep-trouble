extends Node2D
class_name LevelSpecificSettings

@export var shift_camera = ShiftCamera.NO

enum ShiftCamera { NO, UP, RIGHT }

static func find(from: Node) -> LevelSpecificSettings:
	return Utils.map_closest(from, func(node) -> LevelSpecificSettings:
		var level_flags = node.find_children("*", "LevelSpecificSettings", false, false)
		if len(level_flags): return level_flags[0]
		else: return null)
