extends Node2D
class_name Algae

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_2d: Area2D = $Area2D
@onready var audio_player_hide: AudioStreamPlayer2D = $AudioPlayerHide

func _ready():
	animated_sprite_2d.play("default")
	area_2d.body_entered.connect(_on_sub_enter_exit)
	area_2d.body_exited.connect(_on_sub_enter_exit)

func _on_sub_enter_exit(bod):
	if bod is Sub and not GlobalMusicPlayer.is_muted:
		audio_player_hide.play()
