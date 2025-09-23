extends Node

@onready var start: Button = $SettingsMenu/Start

func _ready():
	start.pressed.connect(func():
		LevelRotator.story_level(self))

	get_window().size_changed.connect(_layout)
	_layout.call_deferred()

	_dev_auto_skip.call_deferred()

func _layout():
	var vp = get_viewport()
	if vp:
		self.set_deferred("size", vp.size)

## See PauseMenu
func _dev_auto_skip():
	var skip_to_lvl = SaveGame.get_saved_state().get("developer_auto_jump", -1)
	if skip_to_lvl > -1:
		var json_only_has_floats = floori(skip_to_lvl)
		LevelRotator.dev_change_level(self, json_only_has_floats)
