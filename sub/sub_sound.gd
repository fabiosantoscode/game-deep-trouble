extends Node2D

@onready var sub: Sub = $".."
@onready var audio_dock: AudioStreamPlayer2D = $AudioDock
@onready var audio_engine: AudioStreamPlayer2D = $AudioEngine

@onready var initial_engine_volume = audio_engine.volume_linear
@onready var initial_engine_pitch = audio_engine.volume_linear

var engine_volume_change_rate = 10.0
var engine_volume_stop_rate = 4.0

var engine_pitch_rise_rate = 1.5
var engine_pitch_lower_rate = 8.0

var was_docked = false

func _ready() -> void:
	if GlobalMusicPlayer.is_muted: return

	audio_engine.volume_linear = 0.0

func _physics_process(delta: float) -> void:
	if GlobalMusicPlayer.is_muted: return

	var should_have_engine_sound = sub.get_desired_speed_percent().length() > 0.1
	if should_have_engine_sound:
		if not audio_engine.playing:
			audio_engine.volume_linear = 0.0
			audio_engine.pitch_scale = initial_engine_pitch
			audio_engine.play()
		else:
			audio_engine.volume_linear = _clamp01(audio_engine.volume_linear + engine_volume_change_rate * delta)
			audio_engine.pitch_scale = _clamp01(audio_engine.pitch_scale + engine_pitch_rise_rate * delta)
	else:
		if audio_engine.playing:
			audio_engine.volume_linear = _clamp01(audio_engine.volume_linear - engine_volume_stop_rate * delta)
			audio_engine.pitch_scale = clampf(audio_engine.pitch_scale - engine_pitch_lower_rate * delta, initial_engine_pitch, 2.0)
			if audio_engine.volume_linear <= 0.01:
				audio_engine.stop()

	if not was_docked and sub.has_rock != null:
		audio_dock.play()
	was_docked = sub.has_rock != null

func _clamp01(vol: float):
	return clampf(vol, 0.0, 1.0)
