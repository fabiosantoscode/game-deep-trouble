extends Node2D

@onready var sub: Sub = $".."
@onready var audio_dock: AudioStreamPlayer2D = $AudioDock
@onready var audio_engine: AudioStreamPlayer2D = $AudioEngine

var was_docked = false

func _physics_process(delta: float) -> void:
	if GlobalMusicPlayer.is_muted: return

	if audio_engine.playing:
		if sub.get_inertia().length_squared() < 1.0:
			audio_engine.stop()
	else:
		if sub.get_inertia().length_squared() > 10.0:
			audio_engine.play()

	if not was_docked and sub.has_rock != null:
		audio_dock.play()
	was_docked = sub.has_rock != null
