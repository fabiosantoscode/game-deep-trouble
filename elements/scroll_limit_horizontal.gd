extends Node2D

class_name ScrollLimitHorizontal

func min_x(): return self.position.x
func max_x(): return min_x() + get_viewport().size.x

func _ready() -> void:
	self.visible = false
