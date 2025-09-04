extends Node2D
class_name EnemySub

@export_range(0.0, 1.0, 0.01) var initial_progress = 0.0
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
	path_follow.progress_ratio = initial_progress

	# Kick it off
	_physics_process(0.01)
	_physics_process(0.01)

func _physics_process(delta: float) -> void:
	assert(self.progress_ratio_per_second != null)

	self.path_follow.progress_ratio += self.progress_ratio_per_second * delta

	var old_pos = enemy_sub_agent.global_position
	enemy_sub_agent.global_position = self.path_follow.global_position

	_update_visuals(old_pos, enemy_sub_agent.global_position, self.path_follow.global_rotation)
	for in_vision in enemy_sub_agent.vision_area.get_overlapping_areas():
		enemy_sub_agent._on_player_seen(in_vision)

func _update_visuals(old_pos, new_pos, ang):
	var x_delta = new_pos.x - old_pos.x
	var y_delta = new_pos.y - old_pos.y

	var rotate = 0.0 # radians from Vector2.RIGHT, because the sprite faces right
	var do_hflip = false
	if absf(x_delta) > 0.01 or absf(y_delta) > 0.01:
		if absf(x_delta) > absf(y_delta):
			if x_delta < 0.0:
				do_hflip = true
			else:
				pass
		else:
			if y_delta < 0.0: rotate = -(TAU/4.0) # face up
			else:             rotate = TAU/4.0

	enemy_sub_agent.visual.rotation = rotate
	enemy_sub_agent.visual.flip_h = do_hflip

	enemy_sub_agent.vision_cone_rotator.rotation = ang
