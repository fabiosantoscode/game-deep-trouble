extends Node2D

@onready var sub: Sub = $".."

@export var cutscene_duration = 2.0
@export var cutscene_direction = Vector2.RIGHT

func _ready() -> void:
	# we are the sub's child. our _ready is called first
	if not sub.is_node_ready():
		await sub.ready
	sub.set_input_override(cutscene_direction)
	await get_tree().create_timer(cutscene_duration).timeout
	sub.set_input_override(null)
