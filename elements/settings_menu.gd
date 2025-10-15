extends VBoxContainer

@onready var music: CheckButton = $Music
@onready var full_screen: CheckButton = $FullScreen

func _ready() -> void:
	full_screen.button_pressed = FullscreenKey.is_fullscreen()
	FullscreenKey.fullscreen_change.connect(func(is_on):
		if is_on != full_screen.button_pressed:
			full_screen.button_pressed = FullscreenKey.is_fullscreen(),
		CONNECT_DEFERRED
	)
	full_screen.toggled.connect(func(is_on):
		if is_on != FullscreenKey.is_fullscreen():
			FullscreenKey.set_fullscreen(is_on),
		CONNECT_DEFERRED
	)

	music.button_pressed = not GlobalMusicPlayer.is_muted
	music.toggled.connect(func(is_on):
		GlobalMusicPlayer.is_muted = not is_on)
