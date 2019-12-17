extends Sprite

#var t : float = 0
#var Current_position : Vector2
#var Target_position : Vector2 = self.position
#
#func _input(event):
#		pass
#
#
#func _process(delta):
#	t += delta * 0.004
#
#	if Input.is_action_just_pressed("ui_leftclic"):
#		Target_position = get_global_mouse_position()
#		Current_position = self.position
#
#	self.position = self.position.linear_interpolate(Target_position, t)
#	Tween
#	pass
