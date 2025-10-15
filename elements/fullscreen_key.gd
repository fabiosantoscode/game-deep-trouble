extends Node2D

@onready var wnd = get_window()

signal fullscreen_change(bool)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_F11:
			toggle_fullscreen()
		if (event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER
			and event.alt_pressed):
			toggle_fullscreen()

func toggle_fullscreen():
	set_fullscreen(not is_fullscreen())

func is_fullscreen():
	return wnd.mode == Window.MODE_FULLSCREEN

func set_fullscreen(fullscreen: bool):
	wnd.mode = Window.MODE_FULLSCREEN if fullscreen else Window.MODE_WINDOWED
	# takes some time to switch to fullscreen
	await get_tree().create_timer(1.0).timeout
	fullscreen_change.emit(is_fullscreen())
