extends Position2D

func _process(delta):
	self.position = Vector2(get_global_mouse_position().x,get_global_mouse_position().y)
	