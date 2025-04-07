extends Node2D

signal is_enabled_change()
var is_enabled = false

var virtual_joystick_position = Vector2.ZERO

func set_joystick_enabled(enabled = true):
	is_enabled = enabled
	$Canvas/VirtualJoystick.process_mode = Node.PROCESS_MODE_INHERIT if enabled else Node.PROCESS_MODE_DISABLED
	$Canvas/VirtualJoystick.visible = enabled
	$Canvas/Stick.process_mode = Node.PROCESS_MODE_INHERIT if enabled else Node.PROCESS_MODE_DISABLED
	$Canvas/Stick.visible = enabled
	$Canvas/Button.process_mode = Node.PROCESS_MODE_INHERIT if enabled else Node.PROCESS_MODE_DISABLED
	is_enabled_change.emit()

func _ready() -> void:
	set_joystick_enabled(is_enabled)
	$Canvas/VirtualJoystick.analogic_change.connect(func(xy):
		if not is_enabled: return
		virtual_joystick_position = xy)
	$Canvas/VirtualJoystick.analogic_released.connect(func():
		if not is_enabled: return
		virtual_joystick_position = Vector2.ZERO)

	$Canvas/Button.button_down.connect(func():
		if not is_enabled: return
		$Canvas/Stick.modulate = Color('#24ffff')
		var ev = InputEventAction.new()
		ev.action = "shoot"
		ev.pressed = true
		Input.parse_input_event(ev))
	$Canvas/Button.button_up.connect(func():
		if not is_enabled: return
		$Canvas/Stick.modulate = Color('#ffffff')
		var ev = InputEventAction.new()
		ev.action = "shoot"
		ev.pressed = false
		Input.parse_input_event(ev)
		)
