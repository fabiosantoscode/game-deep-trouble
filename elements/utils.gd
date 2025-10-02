extends RefCounted
class_name Utils

static func frame_independent_lerp(from, to, amount: float, delta: float):
	var e = 2.718281828459045
	return lerp(from, to, 1 - pow(e, -amount * delta))

## Goes up the node tree until `map_or_null` returns non-null
## var found = map_closest(self, func(node): return find_or_null(node))
static func map_closest(from: Node, map_or_null: Callable):
	var cur = from
	while cur is Node:
		var ret = map_or_null.call(cur)
		if ret != null: return ret
		cur = cur.get_parent()
	return null

static func spawn(parent: Node, child, position = null):
	if child is String and (child.begins_with("res://") or child.begins_with("uid://")):
		child = load(child)
	if child is PackedScene:
		child = child.instantiate()
	parent.add_child(child)
	child.owner = parent
	if position != null:
		child.global_position = position
	return child

## Decrement "wait" key of a dictionary. Tells you if it reached zero
static func decrement_wait(dict: Dictionary, delta: float) -> bool:
	var wait = dict.get("wait", 0.0)
	if wait > 0.0:
		dict["wait"] = maxf(wait - delta, 0.0)
		return wait == 0.0
	return false

static func clear_children(node: Node):
	for child in node.get_children():
		child.queue_free()
		node.remove_child(child)

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
		half_length = length / 2.0
		for i in range(floori(length)):
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
