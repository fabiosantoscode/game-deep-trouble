@tool

extends Node2D
class_name EndOfContent

@onready var tool: Polygon2D = $Tool

enum Direction { RIGHT = 0, BOTTOM, LEFT, TOP }

@export var direction = Direction.RIGHT :
	set(dir): direction = dir; _update_tool()

func _ready() -> void:
	_update_tool()

func _update_tool():
	if tool != null:
		tool.visible = Engine.is_editor_hint()
		tool.rotation = direction * (TAU / 4.0)
