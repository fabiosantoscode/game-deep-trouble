extends Node

@onready var start: Button = $SettingsMenu/Start

func _ready():
	start.pressed.connect(func():
		LevelRotator.start_game(self))

	get_window().size_changed.connect(_layout)
	_layout.call_deferred()

func _layout():
	var vp = get_viewport()
	if vp:
		self.set_deferred("size", vp.size)
