extends CharacterBody2D
class_name RockDropped

const ROCK_DROPPED = preload("res://elements/rock_dropped.tscn")

var sub: Sub
var drop_speed = 140.0
var damping_factor = 0.2
var _inertia = Vector2.ZERO
static var initial_inertia = 200.0

@onready var hitbox: Area2D = $Hitbox

static func create_dropped_rock(sub: Sub, new_parent: Node2D, pos: Vector2):
	var rock = ROCK_DROPPED.instantiate()
	rock.sub = sub
	var input = sub.get_last_movement_input()
	if absf(input.x) > 0.5:
		rock._inertia = Vector2(initial_inertia * sign(input.x), 0)
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

func _physics_process(delta: float) -> void:
	self.velocity = Vector2.DOWN * drop_speed
	_inertia *= (1.0 - damping_factor * delta)
	self.velocity += _inertia
	var did_collide = self.move_and_slide()
	if did_collide and self.is_on_floor():
		self.become_rock_plain(sub.owner)

func become_rock_plain(parent: Node2D):
	Rock.create_rock(parent, self.global_position)
	self.queue_free()
