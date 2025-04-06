extends CharacterBody2D
class_name RockDropped

const ROCK_DROPPED = preload("res://elements/rock_dropped.tscn")

var sub: Sub
var drop_speed = 200.0
var damping_factor = 0.2
var _inertia = Vector2.ZERO
static var initial_inertia = 200.0

@onready var hitbox: Area2D = $Hitbox

static func create_dropped_rock(sub: Sub, new_parent: Node2D, pos: Vector2):
	var rock = ROCK_DROPPED.instantiate()
	rock.sub = sub
	new_parent.add_child(rock)
	rock.owner = new_parent
	rock.global_position = pos

func _on_ground_entered(ground):
	self.become_rock_plain(ground.owner)

func _on_enemy_entered(enemy):
	if enemy == sub: return
	enemy.damage()

func _ready():
	#rock_dropped.body_entered.connect(_on_ground_entered)
	hitbox.body_entered.connect(_on_enemy_entered)
	await get_tree().create_timer(0.3).timeout
	hitbox.set_collision_layer_value(4, 1)

func _physics_process(delta: float) -> void:
	self.velocity = Vector2.DOWN * drop_speed
	_inertia *= (1.0 - damping_factor * delta)
	self.velocity += _inertia
	var did_collide = self.move_and_slide()
	if did_collide and self.is_on_floor():
		self.become_rock_plain(sub.owner)

func become_rock_plain(parent: Node2D):
	var rock = Rock.create_rock(parent, self.global_position)
	if not GlobalMusicPlayer.is_muted:
		var thud_sound = AudioStreamPlayer2D.new()
		thud_sound.stream = preload("res://sfx/thud.mp3")
		self.owner.add_child(thud_sound)
		thud_sound.owner = self.owner
		thud_sound.global_position = self.owner.global_position
		thud_sound.play()
	self.queue_free()
