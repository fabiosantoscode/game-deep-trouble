extends Node2D
class_name SubRockGrabbing

@onready var grab_rock_detector: Area2D = $GrabRock
@onready var sub: Sub = $".."

func _ready():
	grab_rock_detector.area_entered.connect(_grab_rock)

func _grab_rock(area):
	if area is Rock:
		if not sub.has_rock:
			sub.assimilate_rock(area)
		else:
			print("warning: Sub already has a rock!")
