extends CharacterBody2D
class_name Sub

@onready var sub_movement: SubMovement = $SubMovement
@onready var sub_input: SubInput = $SubInput
@onready var sub_visuals: SubVisuals = $SubVisuals
@onready var sub_rock_grabbing: SubRockGrabbing = $SubRockGrabbing

var has_rock: RockGrabbed = null

func _physics_process(delta: float) -> void:
	var mov = sub_input.get_movement_input(self)
	sub_movement.move_sub(self, mov, delta)
	sub_visuals.is_facing_left = sub_movement.should_face_left(mov)
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

func get_inertia():
	return sub_movement.inertia

func get_speed_percent():
	return sub_movement.speed_percent
