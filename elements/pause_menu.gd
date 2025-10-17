extends CanvasLayer
class_name PauseMenu

@onready var background: Polygon2D = $Background
@onready var button_resume: Button = $Margins/VBoxContainer/HBoxContainer/SettingsMenu/ButtonResume

func _on_pause():
	button_resume.grab_focus.call_deferred()

func _on_resume():
	pass

func _focus_exited():
	if not LevelRotator.is_in_title_screen(self):
		set_paused(true)

func set_paused(is_paused):
	if get_tree().paused == is_paused:
		return

	get_tree().paused = is_paused
	_layout()
	if is_paused: _on_pause()
	else: _on_resume()

func _layout():
	self.visible = get_tree().paused
	var sz = get_viewport().size
	background.scale = Vector2(sz)

func _ready():
	get_viewport().size_changed.connect(_layout)
	_layout()
	button_resume.pressed.connect(func(): set_paused(false))
	get_window().focus_exited.connect(_focus_exited)

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		set_paused(not get_tree().paused)
