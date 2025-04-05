extends Node2D
class_name SubVisuals

@export var is_facing_left = false:
	set(val): is_facing_left = val; _update_visuals()
	get: return is_facing_left

@export var claw_is_out = false:
	set(val): claw_is_out = val; _update_visuals()
	get: return claw_is_out

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var claw: Sprite2D = $Claw

func _update_visuals():
	if sprite == null: return # this is null before _ready()
	claw.visible = claw_is_out
	sprite.flip_h = self.is_facing_left
	claw.flip_h = self.is_facing_left

func _ready(): _update_visuals()
