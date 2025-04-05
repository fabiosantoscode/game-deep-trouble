extends CharacterBody2D
class_name Sub

@onready var sub_movement: SubMovement = $SubMovement
@onready var sub_input: SubInput = $SubInput
@onready var sub_visuals: SubVisuals = $SubVisuals
@onready var sub_rock_grabbing: SubRockGrabbing = $SubRockGrabbing

@export var is_enemy = false

var has_rock: RockGrabbed = null

func get_last_movement_input():
	return sub_input.last_movement_input

func _physics_process(delta: float) -> void:
	var mov = sub_input.get_movement_input(self)
	sub_movement.move_sub(self, mov, delta)
	sub_visuals.is_facing_left = sub_movement.should_face_left(mov)
	sub_visuals.claw_is_out = has_rock != null or sub_rock_grabbing.close_to_rock
	sub_visuals.is_enemy = is_enemy
	sub_rock_grabbing.try_grab_rock(self)
	sub_rock_grabbing.try_drop_rock(self)

func assimilate_rock(rock: Rock):
	sub_movement.reset_inertia()

	assert(has_rock == null)
	has_rock = rock.become_grabbed(self)

func drop_rock():
	assert(has_rock != null)
	has_rock.become_dropped_rock(self)

func _ready():
	if not is_enemy:
		return
		var cam = Camera2D.new()
		self.add_child(cam)
		cam.owner = self
