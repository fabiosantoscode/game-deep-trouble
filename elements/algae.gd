extends Node2D
class_name Algae

@export var stealth_modulate = Color.WHITE
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_2d: Area2D = $Area2D
@onready var audio_player_hide: AudioStreamPlayer2D = $AudioPlayerHide

func _ready():
	animated_sprite_2d.play("default")
	area_2d.body_entered.connect(_on_sub_enter)
	area_2d.body_exited.connect(_on_sub_exit)

## Globally count subs that are hidden, making sure not to play the sound too much
static var global_hidden_sub_count = 0

func _on_sub_exit(bod):
	if bod is not Sub: return

	self.modulate = Color.WHITE

	global_hidden_sub_count -= 1
	if global_hidden_sub_count == 0:
		bod.stealth_changed.emit(global_hidden_sub_count == 1)
		_play_sound()

func _on_sub_enter(bod):
	if bod is not Sub: return

	self.modulate = self.stealth_modulate

	global_hidden_sub_count += 1
	if global_hidden_sub_count == 1:
		bod.stealth_changed.emit(global_hidden_sub_count == 1)
		_play_sound()

func _play_sound():
	if not GlobalMusicPlayer.is_muted:
		audio_player_hide.play()
