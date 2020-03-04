extends Node2D

func _ready():
	if get_parent().scale.x < 0:
		self.scale.x = -1