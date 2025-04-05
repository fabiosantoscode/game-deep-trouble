extends Node2D
class_name EnemySubAgent

@onready var visual: AnimatedSprite2D = $Visual

func _ready():
	visual.play("default")

func _physics_process(delta: float) -> void:
	var enemy_sub: EnemySub = self.owner
	if enemy_sub.progress_ratio_per_second == null:
		return

	enemy_sub.path_follow.progress_ratio += enemy_sub.progress_ratio_per_second * delta

	var old_pos = self.global_position
	self.global_position = enemy_sub.path_follow.global_position

	_update_visuals(old_pos, self.global_position)

func _update_visuals(old_pos, new_pos):
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
			if y_delta < 0.0:
				rotate = -(TAU/4.0) # face up
			else:
				rotate = TAU / 4.0

	visual.rotation = rotate
	visual.flip_h = do_hflip
