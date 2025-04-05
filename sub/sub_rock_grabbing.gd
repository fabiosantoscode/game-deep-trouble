extends Node2D
class_name SubRockGrabbing

@onready var grab_rock_detector: Area2D = $GrabRock
@onready var can_grab_rock_detector: Area2D = $CanGrabRock

var close_to_rock = false
## Set to a Rock when we can grab it
var _rock_to_grab: Rock = null

func _ready():
	grab_rock_detector.area_entered.connect(_update_grab_rock)
	can_grab_rock_detector.area_entered.connect(_update_can_grab_rock)

func try_grab_rock(sub: Sub):
	if _rock_to_grab != null and not sub.has_rock:
		sub.assimilate_rock(_rock_to_grab)
		_rock_to_grab = null

func _update_grab_rock(area):
	if area is Rock:
		_rock_to_grab = area

func _update_can_grab_rock(_area):
	var rocks = (
		can_grab_rock_detector.get_overlapping_areas()
			.filter(func(a): return a is Rock)
	)
	self.close_to_rock = len(rocks) > 0
