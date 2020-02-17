extends Sprite

# warning-ignore:unused_argument
func _input(event):
	if Input.is_action_just_pressed("ui_leftclic"):
		if (abs(get_local_mouse_position().x) < 32
		&& abs(get_local_mouse_position().y) < 64):
			get_parent().value = max(1, get_parent().value-1)

	if (Input.is_action_pressed("ui_leftclic")
	&& abs(get_local_mouse_position().x) < 32
	&& abs(get_local_mouse_position().y) < 64):
		var Clicked = load("res://Scenes/FIGHTMODE/A_SelectionMenu/Resources/SelectionPanel/Selecteur_fleche_inverse.png")
		self.texture = Clicked
	else:
		var Clicked = load("res://Scenes/FIGHTMODE/A_SelectionMenu/Resources/SelectionPanel/Selecteur_fleche.png")
		self.texture = Clicked