extends Node2D

class_name ScrollLimitVertical

func min_y(): return self.position.y
func max_y(): return min_y() + get_viewport().size.y

func _ready() -> void:
	self.visible = false
