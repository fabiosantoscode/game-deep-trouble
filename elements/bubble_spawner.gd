extends Node2D

@export var rate = 1.0
@export var time_to_live = 5.0
@export var speed = 25.0
@export var moveapart_speed = 2.0
@export var sway_ang_speed = 30.0
@export var sway_width = 10
@onready var template: Sprite2D = $Template

var time_to_next = 0.0
var bubbles = []

func _process(delta):
	_spawn_new_bubbles(delta)

	for i in range(len(bubbles)):
		var bubble = bubbles[i]
		bubble["bubble"].global_position += Vector2.UP * bubble["speed"] * delta
		# sway oscillates between left/right
		bubble["sway"] += delta * sway_ang_speed
		bubble["bubble"].global_position += Vector2.RIGHT * sin(bubble["sway"]) * delta
		# tear them apart
		var prev_bubble = bubbles[i - 1]["bubble"] if i > 0 else null
		if prev_bubble != null and absf(prev_bubble.global_position.y - bubble["bubble"].global_position.y) < 16.0:
			var dist = prev_bubble.global_position.x - bubble["bubble"].global_position.x
			if absf(dist) < 16.0:
				bubble["bubble"].global_position += Vector2.LEFT * sign(dist) * moveapart_speed * delta

	for bubble in bubbles:
		bubble["ttl"] -= delta
		if bubble["ttl"] <= 0:
			bubble["bubble"].queue_free()
			self.remove_child(bubble["bubble"])
			bubbles.remove_at(bubbles.find(bubble))

func _spawn_new_bubbles(delta):
	time_to_next -= delta
	if time_to_next <= 0:
		time_to_next = rate * randf_range(0.9, 1.1)
		if randi_range(0, 5) == 0:
			# random quick spawn
			time_to_next /= 4
		var bubble = template.duplicate()
		bubble.visible = true
		self.add_child(bubble)
		bubble.owner = self
		bubbles.push_back({
			"bubble": bubble,
			"ttl": randf_range(time_to_live * 0.8, time_to_live * 1.2),
			"sway": randf_range(0, TAU),
			"speed": randf_range(speed * 0.6, speed * 1.4),
		})
