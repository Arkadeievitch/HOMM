extends Sprite

var clicked_path : String = "res://Scenes/FIGHTMODE/A_SelectionMenu/Resources/SelectionPanel/ColorSelection/Selecteur_fleche_inverse.png"
var unclicked_path : String = "res://Scenes/FIGHTMODE/A_SelectionMenu/Resources/SelectionPanel/ColorSelection/Selecteur_fleche.png"

# warning-ignore:unused_argument
func _input(event):
	if Input.is_action_just_pressed("ui_leftclic"):
		if (abs(get_local_mouse_position().x) < 32
		&& abs(get_local_mouse_position().y) < 64):
			get_parent().value = min(8, get_parent().value+1)

	if (Input.is_action_pressed("ui_leftclic")
	&& abs(get_local_mouse_position().x) < 32
	&& abs(get_local_mouse_position().y) < 64):
		var Clicked = load(clicked_path)
		self.texture = Clicked
	else:
		var Clicked = load(unclicked_path)
		self.texture = Clicked