extends Node2D
class_name Goal

@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	area_2d.body_entered.connect(_on_sub)

func _on_sub(sub: Sub):
	if sub.has_rock != null:
		LevelRotator.next_level(self)
