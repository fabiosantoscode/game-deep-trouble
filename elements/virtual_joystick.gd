extends Node2D

signal is_enabled_change()
var is_enabled = true

var virtual_joystick_position = Vector2.ZERO

func set_joystick_enabled(enabled = true):
	is_enabled = enabled
	$VirtualJoystick.process_mode = Node.PROCESS_MODE_INHERIT if enabled else Node.PROCESS_MODE_DISABLED
	$VirtualJoystick.visible = enabled
	$Stick.process_mode = Node.PROCESS_MODE_INHERIT if enabled else Node.PROCESS_MODE_DISABLED
	$Stick.visible = enabled
	$Button.process_mode = Node.PROCESS_MODE_INHERIT if enabled else Node.PROCESS_MODE_DISABLED
	is_enabled_change.emit()

func _ready() -> void:
	set_joystick_enabled(false)
	$VirtualJoystick.analogic_change.connect(func(xy):
		if not is_enabled: return
		virtual_joystick_position = xy)
	$VirtualJoystick.analogic_released.connect(func():
		if not is_enabled: return
		virtual_joystick_position = Vector2.ZERO)

	$Button.button_down.connect(func():
		if not is_enabled: return
		$Stick.modulate = Color('#24ffff')
		var ev = InputEventAction.new()
		ev.action = "shoot"
		ev.pressed = true
		Input.parse_input_event(ev))
	$Button.button_up.connect(func():
		if not is_enabled: return
		$Stick.modulate = Color('#ffffff')
		var ev = InputEventAction.new()
		ev.action = "shoot"
		ev.pressed = false
		Input.parse_input_event(ev)
		)
