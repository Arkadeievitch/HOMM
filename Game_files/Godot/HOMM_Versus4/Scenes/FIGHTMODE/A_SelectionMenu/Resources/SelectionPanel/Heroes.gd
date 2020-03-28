extends Node2D

func _ready():
	if self.global_position.x > get_viewport().size.x/2:
		self.scale.x = -1