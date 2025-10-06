extends Node2D
class_name Goal

@onready var area_2d: Area2D = $Area2D
@export var requires_rock = true
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite_2d.play("default")
	area_2d.body_entered.connect(_on_sub)

func _on_sub(sub: Sub):
	if sub.has_rock != null or not requires_rock:
		LevelRotator.next_level.call_deferred(self)
