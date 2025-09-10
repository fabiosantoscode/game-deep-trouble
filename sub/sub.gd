extends CharacterBody2D
class_name Sub

@onready var sub_movement: SubMovement = $SubMovement
@onready var sub_input: SubInput = $SubInput
@onready var sub_visuals: SubVisuals = $SubVisuals
@onready var sub_rock_grabbing: SubRockGrabbing = $SubRockGrabbing

var has_rock: RockGrabbed = null
static var y_distance_to_rock = 13

signal movement_started(direction: Vector2, intensity_01: float)

## Stealth system. When hidden, stealth_changed(true)
signal stealth_changed()
var is_stealthy: bool = false

func _physics_process(delta: float) -> void:
	var player_input = sub_input.get_movement_input()
	sub_movement.move_sub(player_input, delta)
	sub_visuals.is_facing_left = sub_movement.should_face_left(player_input)
	sub_visuals.is_facing_updown = sub_movement.should_face_updown(player_input)
	sub_visuals.claw_is_out = has_rock != null
	sub_rock_grabbing.try_grab_rock(self)
	sub_rock_grabbing.try_drop_rock(self)

func emit_movement_started(movement, rate):
	self.movement_started.emit(movement, rate)

func update_is_stealthy(new_is_stealthy: bool):
	is_stealthy = new_is_stealthy
	self.stealth_changed.emit()

func assimilate_rock(rock: Rock):
	sub_movement.reset_inertia()

	assert(has_rock == null)
	has_rock = rock.become_grabbed(self)

func drop_rock():
	assert(has_rock != null)
	has_rock.become_dropped_rock()

func get_speed_percent():
	return sub_movement.speed_percent

func get_last_input() -> Vector2:
	return sub_input.last_input
