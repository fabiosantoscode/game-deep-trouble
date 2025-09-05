extends Node2D
class_name SubVisuals

@onready var sub: Sub = $".."

@export var stealth_modulate = Color.WHITE

@export var is_facing_left = false:
	set(val): is_facing_left = val; _update_visuals()

## -1 down, 0 ahead, 1 up
@export var is_facing_updown = 0:
	set(val): is_facing_updown = val; _update_visuals()

@export var claw_is_out: bool = false:
	set(val): claw_is_out = val; _update_visuals()

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var sprite_down: AnimatedSprite2D = $SpriteDown
@onready var sprite_up: AnimatedSprite2D = $SpriteUp
@onready var claw: Sprite2D = $Claw
@onready var sub_bubble_trail: SubBubbleTrail = $SubBubbleTrail
@onready var player_sub_glow: Sprite2D = $PlayerSubGlow

func _update_visuals():
	if sprite == null: return # this is null before _ready()

	sprite.modulate = self.stealth_modulate if sub.is_stealthy else Color.WHITE
	sprite_up.modulate = sprite.modulate
	sprite_down.modulate = sprite.modulate

	claw.visible = claw_is_out
	sprite.flip_h = self.is_facing_left
	sprite_up.flip_h = self.is_facing_left
	sprite_down.flip_h = self.is_facing_left
	claw.flip_h = self.is_facing_left

	player_sub_glow.flip_h = self.is_facing_left
	sub_bubble_trail.flip_h = self.is_facing_left
	sub_bubble_trail.is_facing_updown = self.is_facing_updown
	sprite.visible = self.is_facing_updown == 0
	sprite_up.visible = self.is_facing_updown == 1
	sprite_down.visible = self.is_facing_updown == -1

func _ready():
	sprite.play()
	sprite_up.play()
	sprite_down.play()
	sub.stealth_changed.connect(func(_s): _update_visuals())
	_update_visuals()
