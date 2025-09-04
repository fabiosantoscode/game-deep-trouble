extends Node2D
class_name EnemySubAgent

@onready var rotator: Node2D = $Rotator
@onready var vision_area: Area2D = $Rotator/VisionArea
@onready var visual: AnimatedSprite2D = $Visual
@onready var player_kill_area: Area2D = $PlayerKillBox
@onready var receive_death_from_falling_rock: Area2D = $Rotator/ReceiveDeathFromFallingRock


func _ready():
	visual.play("default")
	vision_area.body_entered.connect(_on_player_seen)
	player_kill_area.body_entered.connect(_on_player_kill)
	receive_death_from_falling_rock.area_entered.connect(_on_receive_death)

func _on_player_seen(sub: Node2D):
	if sub != null and sub is Sub and not sub.is_stealthy and _check_vision_ray(sub):
		print("EnemySubAgent: Player seen!")
		LevelRotator.restart_level.call_deferred(self)

func _on_player_kill(sub: Node2D):
	if sub is Sub:
		print("EnemySubAgent: Player touched!")
		LevelRotator.restart_level.call_deferred(self)

func _check_vision_ray(sub: Sub):
	var ray_from = self.global_position
	var ray_to = sub.global_position
	var space_state = get_world_2d().direct_space_state
	var layer_1_or_5_or_6 = $RayCast2D.collision_mask
	var query = PhysicsRayQueryParameters2D.create(ray_from, ray_to, layer_1_or_5_or_6)
	query.exclude = [self]
	query.collide_with_areas = true
	query.collide_with_bodies = true
	var result = space_state.intersect_ray(query)
	return result.get("collider", null) is Sub

func _on_receive_death(_rock):
	if not GlobalMusicPlayer.is_muted:
		var thud_sound = AudioStreamPlayer2D.new()
		thud_sound.stream = preload("res://sfx/explode.mp3")
		self.owner.add_child(thud_sound)
		thud_sound.owner = self.owner
		thud_sound.global_position = self.owner.global_position
		thud_sound.play()
	print("EnemySubAgent: died!")
	self.owner.queue_free()
	self.queue_free()
