extends Node2D
class_name EnemySubAgent

@onready var rotator: Node2D = $Rotator
@onready var vision_area: Area2D = $Rotator/VisionArea
@onready var visual: AnimatedSprite2D = $Visual
@onready var player_kill_area: Area2D = $PlayerKillBox


func _ready():
	visual.play("default")
	vision_area.body_entered.connect(_on_player_seen)
	player_kill_area.body_entered.connect(_on_player_kill)

func _on_player_seen(sub: Node2D):
	if sub == null or not (sub is Sub): return

	var ray_from = self.global_position
	var ray_to = sub.global_position
	var space_state = get_world_2d().direct_space_state
	var layer_1_or_5_or_6 = $RayCast2D.collision_mask
	var query = PhysicsRayQueryParameters2D.create(ray_from, ray_to, layer_1_or_5_or_6)
	query.exclude = [self]
	query.collide_with_areas = true
	query.collide_with_bodies = true
	var result = space_state.intersect_ray(query)
	if result.get("collider", null) is Sub:
		print("TODO: we've been found!")

func _on_player_kill(sub: Node2D):
	if sub is Sub:
		print("TODO: we've been touched!")

func _physics_process(delta: float) -> void:
	var enemy_sub: EnemySub = self.owner
	if enemy_sub.progress_ratio_per_second == null:
		return

	enemy_sub.path_follow.progress_ratio += enemy_sub.progress_ratio_per_second * delta

	var old_pos = self.global_position
	self.global_position = enemy_sub.path_follow.global_position

	_update_visuals(old_pos, self.global_position)
	_rotate_finder(old_pos, self.global_position)
	for in_vision in vision_area.get_overlapping_areas():
		_on_player_seen(in_vision)

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

func _rotate_finder(old_pos: Vector2, new_pos: Vector2):
	if old_pos.distance_to(new_pos) < 0.1: return

	var ang = old_pos.angle_to_point(new_pos)
	rotator.rotation = ang
