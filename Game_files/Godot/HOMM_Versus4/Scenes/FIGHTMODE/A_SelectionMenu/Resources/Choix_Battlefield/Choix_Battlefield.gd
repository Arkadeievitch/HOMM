extends Label

signal Battlefield_chosen

func _ready():
	if has_node("/root/MainNode/SelectionMenu"):
		var MENU = get_node("/root/MainNode/SelectionMenu")
# warning-ignore:return_value_discarded
		self.connect("Battlefield_chosen", MENU, "Select_Battlefield")

# warning-ignore:unused_argument
func _input(event):
	if Input.is_action_just_pressed("ui_leftclic"):
		var Center_GlobalPosition = self.rect_global_position + self.rect_size/2
		if (abs(get_global_mouse_position().x-Center_GlobalPosition.x) < self.rect_size.x/2
		&& abs(get_global_mouse_position().y-Center_GlobalPosition.y) < self.rect_size.y/2):
			self.modulate = Color(1,1,1,1)
			emit_signal("Battlefield_chosen", self.name)
		else:
			var Panel_CenterPosition = get_parent().global_position
			if (abs(get_global_mouse_position().x-Panel_CenterPosition.x) < 128
			&& abs(get_global_mouse_position().y-Panel_CenterPosition.y) < 240):
				self.modulate = Color(1,1,1,0.5)