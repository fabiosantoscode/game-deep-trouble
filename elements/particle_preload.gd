extends Node2D

var materials_to_preload = [
	preload("res://sub/sub_acceleration_boost_particles.tres"),
	preload("res://sub/sub_idle_particles.tres"),
]

var _already_preloaded = false

func preload_particles():
	if _already_preloaded: return
	_already_preloaded = true
	for material in self.materials_to_preload:
		var particle = GPUParticles2D.new()
		particle.process_material = material

		particle.one_shot = true
		particle.lifetime = 0.25
		particle.amount = 1

		self.add_child(particle)
		await get_tree().process_frame
		particle.emitting = true

	await get_tree().process_frame
