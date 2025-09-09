extends Node2D

var materials_to_preload = [
	preload("res://sub/sub_acceleration_boost_particles.tres"),
	preload("res://sub/sub_idle_particles.tres"),
]

var _already_preloaded = false

func preload_particles():
	if _already_preloaded: return
	_already_preloaded = true
	for mat in self.materials_to_preload:
		var particle = GPUParticles2D.new()
		particle.process_material = mat

		particle.preprocess = 1.0
		particle.one_shot = true
		particle.lifetime = 0.5
		#particle.amount = 1
		particle.amount_ratio = 1.0

		self.add_child(particle)
		await get_tree().process_frame
		particle.emitting = true
		await get_tree().process_frame

	await get_tree().create_timer(0.1).timeout
	await get_tree().process_frame
	await get_tree().physics_frame
