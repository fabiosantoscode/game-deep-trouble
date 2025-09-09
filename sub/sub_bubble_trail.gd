class_name SubBubbleTrail

extends Node2D

@onready var sub: Sub = $"../.."
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var boost_particles: GPUParticles2D = $AccelerationBoostParticles

const updown_shift_emitters = 4
var particle_boost_duration = 0.2
var sub_speed_delayed = 0.0

var flip_h: bool:
	set(new_fl): flip_h = new_fl; _update_positions()

var is_facing_updown: int:
	set(new_updown): is_facing_updown = new_updown; _update_positions()

func _ready() -> void:
	_ready_boost()

func _physics_process(delta: float) -> void:
	_bubbles(delta)
	_boost(delta)

func _update_positions():
	var sign_ = 1 if flip_h else -1
	var b_sign = -sign_
	gpu_particles_2d.position.x = sign_ * abs(gpu_particles_2d.position.x)
	boost_particles.position.x = b_sign * abs(boost_particles.position.x)

	gpu_particles_2d.position.y = is_facing_updown * updown_shift_emitters
	boost_particles.position.y = is_facing_updown * -1 * updown_shift_emitters

func _bubbles(delta: float):
	var speed = sub.get_speed_percent()
	self.sub_speed_delayed = (
		Utils.frame_independent_lerp(sub_speed_delayed, speed, 0.2, delta)
		if speed < 0.1
		else speed
	)
	# gpu_particles_2d.emitting = speed > 0.1
	gpu_particles_2d.amount_ratio = sub_speed_delayed * randf_range(0.7, 1.3)

var particle_boost_age = 0.0
func _ready_boost():
	sub.movement_started.connect(_boost_start)

func _boost_start(inertia: Vector2, intensity = 1.0):
	particle_boost_age = 0.0
	boost_particles.emitting = true
	boost_particles.amount_ratio = intensity
	_boost_set_direction(inertia)

func _boost(delta: float):
	if boost_particles.emitting:
		_boost_set_direction(sub.get_last_input())
		particle_boost_age += delta
		if particle_boost_age > particle_boost_duration:
			boost_particles.emitting = false

func _boost_set_direction(new_dir: Vector2):
	if new_dir.length_squared() > 0.1:
		var v3_dir = Vector3(new_dir.x, new_dir.y, 0.0)
		boost_particles.process_material.direction = v3_dir.normalized()
