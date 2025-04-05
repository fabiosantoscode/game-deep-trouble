extends Node2D
class_name EnemySub

@export var progress_ratio_per_second = 1.0
var path_follow: PathFollow2D
@onready var enemy_sub_agent: EnemySubAgent = $EnemySubAgent

func _ready() -> void:
	assert(enemy_sub_agent.owner == self, "hard assumption about who owns who")
	var paths = self.find_children("", "Path2D", true, false)
	assert(len(paths) > 0)
	assert(len(paths) < 2)
	var path = paths[0]
	path_follow = PathFollow2D.new()
	path.add_child(path_follow)
	path_follow.owner = self
