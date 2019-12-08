extends Position2D

func _input(event):
#func _process(delta):
	self.position = Vector2(get_global_mouse_position().x,get_global_mouse_position().y)
	# essai func _input(event) sans déclencheur?
