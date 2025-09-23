extends Control

func _ready():
	_layout.call_deferred()
	get_window().size_changed.connect(_layout)
	wait_then_move_on()

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("skip"):
		LevelRotator.next_level(self)

func wait_then_move_on():
	await get_tree().create_timer(5.0).timeout
	LevelRotator.next_level(self)

func _layout():
	var vp = get_viewport()
	if vp:
		self.size = vp.size
