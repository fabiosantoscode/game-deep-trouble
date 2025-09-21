extends CharacterBody2D
class_name RockDropped

const ROCK_DROPPED = preload("res://elements/rock_dropped.tscn")
const ROCK_THUD_SOUND = preload("res://sfx/thud.mp3")

var sub: Sub
var drop_speed = 200.0
var damping_factor = 0.2
var _inertia = Vector2.ZERO
static var initial_inertia = 200.0

@onready var hitbox: Area2D = $Hitbox
var initial_collision_check = false

static func create_dropped_rock(sub_: Sub, new_parent: Node2D, pos: Vector2):
	var rock: RockDropped = ROCK_DROPPED.instantiate()
	rock.sub = sub_
	new_parent.add_child(rock)
	rock.owner = new_parent
	rock.global_position = pos
	
	var coll = rock.move_and_collide(Vector2.ZERO, true, 0.1, true)
	if coll != null:
		rock.global_position = rock.sub.global_position

func _on_ground_entered(ground):
	self.become_rock_plain(ground.owner)

func _on_enemy_entered(enemy):
	if enemy == sub: return
	enemy.damage()

func _ready():
	#rock_dropped.body_entered.connect(_on_ground_entered)
	hitbox.body_entered.connect(_on_enemy_entered)
	hitbox.set_collision_layer_value(4, 1)

func _physics_process(delta: float) -> void:
	self.velocity = Vector2.DOWN * drop_speed
	_inertia *= (1.0 - damping_factor * delta)
	self.velocity += _inertia
	var did_collide = self.move_and_slide()
	if did_collide and self.is_on_floor():
		self.become_rock_plain(sub.owner)

func become_rock_plain(parent: Node2D):
	self.queue_free()
	Rock.create_rock(parent, self.global_position)
	if not GlobalMusicPlayer.is_muted:
		var thud_sound = AudioStreamPlayer2D.new()
		thud_sound.stream = ROCK_THUD_SOUND
		self.owner.add_child(thud_sound)
		thud_sound.owner = self.owner
		thud_sound.volume_db = -10.0
		thud_sound.global_position = self.owner.global_position
		thud_sound.play()
