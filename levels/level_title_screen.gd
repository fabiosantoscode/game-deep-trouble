extends Node
class_name LevelTitleScreen

@onready var new_game: Button = $SettingsMenu/NewGame
@onready var continue_game: Button = $SettingsMenu/Continue

func _ready():
	new_game.pressed.connect(func():
		LevelRotator.start_game(self, "new_game"))

	continue_game.pressed.connect(func():
		LevelRotator.start_game(self, "continue"))
	continue_game.visible = SaveGame.has_saved_state

	get_window().size_changed.connect(_layout)
	_layout.call_deferred()

func _layout():
	var vp = get_viewport()
	if vp:
		self.set_deferred("size", vp.size)
