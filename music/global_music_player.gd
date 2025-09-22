extends Node2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
var is_muted = true:
	set(new_muted):
		if is_muted == new_muted: return
		is_muted = new_muted
		if is_muted: stop_music()
		else: start_music()

func start_music():
	audio_stream_player.play()

func stop_music():
	audio_stream_player.stop()
