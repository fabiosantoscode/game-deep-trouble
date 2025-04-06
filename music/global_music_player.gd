extends Node2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
var _reasons_to_play = 0
var is_muted = false:
	set(new_muted):
		if is_muted == new_muted: return
		is_muted = new_muted
		if is_muted: stop_music()
		else: start_music()

func start_music():
	_reasons_to_play += 1
	if _reasons_to_play == 1:
		audio_stream_player.play()

func stop_music():
	_reasons_to_play -= 1
	if _reasons_to_play < 1:
		audio_stream_player.stop()
