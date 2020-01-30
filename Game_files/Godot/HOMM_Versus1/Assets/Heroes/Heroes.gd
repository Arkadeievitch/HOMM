extends Node2D

# warning-ignore:unused_argument
#func _input(event):
#	if Input.is_action_just_pressed("ui_rightclic"):
#		clearCurrent()
#		HeroesInformation()
#
#func HeroesInformation():
#	if (abs(get_global_mouse_position().x-self.global_position.x) < 32
#	&& abs(get_global_mouse_position().y-self.global_position.y) < 32):
#		var InformationPanel = load("InformationPanel")
#		add_child(InformationPanel.instance(), true)
#
#func clearCurrent():
#	if get_child_count() > 0:
#		get_child(0).queue_free()