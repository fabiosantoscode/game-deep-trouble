extends Node2D
class_name SubRockGrabbing

@onready var grab_rock_detector: Area2D = $GrabRock

## Set to a Rock when we can grab it
var _rock_to_grab: Rock = null

func _ready():
	grab_rock_detector.area_entered.connect(_update_grab_rock)

func try_grab_rock(sub: Sub):
	if _rock_to_grab != null and not sub.has_rock:
		sub.assimilate_rock(_rock_to_grab)
		_rock_to_grab = null

func try_drop_rock(sub: Sub):
	if sub.has_rock and Input.is_action_just_pressed("shoot"):
		sub.drop_rock()

func _update_grab_rock(area):
	if area is Rock:
		_rock_to_grab = area
