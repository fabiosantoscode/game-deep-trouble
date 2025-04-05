extends Node2D
class_name Algae

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	animated_sprite_2d.play("default")
