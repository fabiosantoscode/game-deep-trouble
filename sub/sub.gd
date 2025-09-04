extends CharacterBody2D
class_name Sub

@onready var sub_movement: SubMovement = $SubMovement
@onready var sub_input: SubInput = $SubInput
@onready var sub_visuals: SubVisuals = $SubVisuals
@onready var sub_rock_grabbing: SubRockGrabbing = $SubRockGrabbing

var has_rock: RockGrabbed = null
@export var y_distance_to_rock = 13

## Stealth system. When hidden, stealth_changed(true)
signal stealth_changed(is_stealthy: bool)
var is_stealthy: bool = false

func _ready():
	self.stealth_changed.connect(func(is_s):
		self.is_stealthy = is_s)

func _physics_process(delta: float) -> void:
	var player_input = sub_input.get_movement_input(self)
	sub_movement.move_sub(self, player_input, delta)
	sub_visuals.is_facing_left = sub_movement.should_face_left(player_input)
	sub_visuals.claw_is_out = has_rock != null
	sub_rock_grabbing.try_grab_rock(self)
	sub_rock_grabbing.try_drop_rock(self)

func assimilate_rock(rock: Rock):
	sub_movement.reset_inertia()

	assert(has_rock == null)
	has_rock = rock.become_grabbed(self)

func drop_rock():
	assert(has_rock != null)
	has_rock.become_dropped_rock(self)

func get_speed_percent():
	return sub_movement.speed_percent

func get_desired_speed_percent():
	return sub_input.last_input
