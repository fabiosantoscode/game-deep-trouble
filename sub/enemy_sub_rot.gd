extends Node2D
class_name EnemySubRot

@export_range(-180.0, 180.0, 5.0) var max_angle = 0.0
@export var rotation_cycle_duration = 1.0

@onready var enemy_sub_agent: EnemySubAgent = $EnemySubAgent
@onready var original_rotation = self.rotation

func _ready() -> void:
	assert(enemy_sub_agent.owner == self, "hard assumption about who owns who")
	
	var start = self.rotation
	var end = start + deg_to_rad(max_angle)

	var ang_tween = self.create_tween()
	ang_tween.tween_property(self, "rotation", end, rotation_cycle_duration / 2.0)
	ang_tween.tween_property(self, "rotation", start, rotation_cycle_duration / 2.0)
	ang_tween.set_loops()
