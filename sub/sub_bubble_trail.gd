class_name SubBubbleTrail

extends Node2D

@onready var sub: Sub = $"../.."
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

var sub_speed_delayed = 0.0

func _physics_process(delta: float) -> void:
	var speed = sub.get_speed_percent()
	self.sub_speed_delayed = (
		frame_independent_lerp(sub_speed_delayed, speed, 0.2, delta)
		if speed < 0.1
		else speed
	)
	# gpu_particles_2d.emitting = speed > 0.1
	gpu_particles_2d.amount_ratio = sub_speed_delayed * randf_range(0.7, 1.3)

static func frame_independent_lerp(from, to, amount: float, delta: float):
	var e = 2.71828
	return lerp(from, to, 1 - pow(e, -amount * delta))
