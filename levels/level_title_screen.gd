extends Node

@onready var start: Button = $SettingsMenu/Start

func _ready():
	start.pressed.connect(func():
		LevelRotator.story_level(self))

	_layout()
	get_window().size_changed.connect(_layout)

func _layout():
	var vp = get_viewport()
	if vp:
		self.set_deferred("size", vp.size)
