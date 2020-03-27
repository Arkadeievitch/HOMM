extends Position2D

# warning-ignore:unused_argument
func _input(event):
	if (Input.is_action_just_pressed("ui_rightclic")
	|| Input.is_action_just_pressed("ui_leftclic")):
		self.queue_free()