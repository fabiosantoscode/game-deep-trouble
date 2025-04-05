extends CharacterBody2D
class_name Sub

@onready var sub_movement: SubMovement = $SubMovement
@onready var sub_input: SubInput = $SubInput
@onready var sub_visuals: SubVisuals = $SubVisuals
@onready var sub_rock_grabbing: SubRockGrabbing = $SubRockGrabbing

var has_rock: Sprite2D = null

func _physics_process(delta: float) -> void:
	var mov = sub_input.get_movement_input()
	sub_movement.move_sub(self, mov, delta)
	sub_visuals.is_facing_left = sub_movement.should_face_left(mov)
	sub_visuals.claw_is_out = has_rock != null or sub_rock_grabbing.close_to_rock
	sub_rock_grabbing.try_grab_rock(self)

func assimilate_rock(rock: Rock):
	assert(has_rock == null)

	sub_movement.reset_inertia()
	rock.queue_free()
	var pos = rock.sprite.global_position
	has_rock = rock.sprite.duplicate()
	self.add_child(has_rock)
	has_rock.owner = self
	has_rock.global_position = pos
