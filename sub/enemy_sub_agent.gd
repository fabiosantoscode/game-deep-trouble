extends Node2D
class_name EnemySubAgent

@onready var vision_cone_rotator: Node2D = $VisionConeRotator
@onready var vision_area: Area2D = $VisionConeRotator/VisionArea
@onready var visual: AnimatedSprite2D = $SubSprite
@onready var player_kill_area: Area2D = $PlayerKillArea
@onready var receive_death_from_falling_rock: Area2D = $ReceiveDeathFromFallingRock
@onready var vision_ray_template: RayCast2D = $VisionRayTemplate


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
	if sub is Sub and not sub.is_stealthy:
		print("EnemySubAgent: Player touched!")
		LevelRotator.restart_level.call_deferred(self)

func _check_vision_ray(sub: Sub):
	var query = PhysicsRayQueryParameters2D.create(
		self.global_position,
		sub.global_position,
		vision_ray_template.collision_mask
	)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	var result = get_world_2d().direct_space_state.intersect_ray(query)
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
