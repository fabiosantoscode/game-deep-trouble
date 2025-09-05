extends Node2D
class_name SubVisuals

@onready var sub: Sub = $".."

@export var stealth_modulate = Color.WHITE

@export var is_facing_left = false:
	set(val): is_facing_left = val; _update_visuals()

@export var claw_is_out: bool = false:
	set(val): claw_is_out = val; _update_visuals()

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var claw: Sprite2D = $Claw
@onready var sub_bubble_trail: SubBubbleTrail = $SubBubbleTrail
@onready var player_sub_glow: Sprite2D = $PlayerSubGlow

func _update_visuals():
	if sprite == null: return # this is null before _ready()
	sprite.modulate = self.stealth_modulate if sub.is_stealthy else Color.WHITE
	claw.visible = claw_is_out
	sprite.flip_h = self.is_facing_left
	claw.flip_h = self.is_facing_left
	player_sub_glow.flip_h = self.is_facing_left
	sub_bubble_trail.flip_h = self.is_facing_left

func _ready():
	sprite.play()
	sub.stealth_changed.connect(func(_s): _update_visuals())
	_update_visuals()
