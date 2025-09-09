extends Node

@onready var start: Button = $Menu/Start
@onready var music: CheckButton = $Menu/Music
@onready var full_screen: CheckButton = $Menu/FullScreen
@onready var menu: VBoxContainer = $Menu

func _ready():
	full_screen.toggled.connect(func(is_on):
		get_window().mode = Window.MODE_FULLSCREEN if is_on else Window.MODE_WINDOWED
		)
	music.toggled.connect(func(is_on):
		if is_on: GlobalMusicPlayer.start_music()
		else: GlobalMusicPlayer.stop_music())
	start.pressed.connect(func():
		LevelRotator.story_level(self))
	
	_layout()
	get_window().size_changed.connect(_layout)

func _layout():
	self.size = get_viewport().size
