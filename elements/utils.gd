extends RefCounted
class_name Utils

static func frame_independent_lerp(from, to, amount: float, delta: float):
	var e = 2.718281828459045
	return lerp(from, to, 1 - pow(e, -amount * delta))

class AverageVector:
	var arr = [Vector2.ZERO]
	var index = 0
	var sum = Vector2.ZERO
	var length = 1
	var half_length = 0
	var pushes = 0
	var is_new = true

	func _init(seconds: float):
		length = floori(Engine.physics_ticks_per_second * seconds)
		half_length = length / 2
		for i in range(length):
			arr.push_back(Vector2.ZERO)

	func reset():
		if is_new: return
		is_new = true
		for i in range(length):
			arr[i] = Vector2.ZERO
		sum = Vector2.ZERO
		index = 0
		pushes = 0

	func push(new_vec: Vector2):
		is_new = false
		sum -= arr[index]
		sum += new_vec
		arr[index] = new_vec
		index = (index + 1) % length
		pushes += 1

	func is_filled():
		return pushes > half_length

	func average():
		return sum / float(length)
