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
			
			var Texture_path = str("res://Scenes/FIGHTMODE/A_SelectionMenu/Resources/Choix_Battlefield/Icones_Terrains/", self.name, ".png")
			get_parent().get_parent().get_node("BG_Choix_Battlefield").texture = load(Texture_path)
			
			emit_signal("Battlefield_chosen", self.name)
		else:
			var SELECTION_ZONE = get_parent().get_parent().get_node("SelectionZone")
			var Panel_CenterPosition = SELECTION_ZONE.rect_global_position + SELECTION_ZONE.rect_size/2
			if (abs(get_global_mouse_position().x-Panel_CenterPosition.x) < SELECTION_ZONE.rect_size.x/2
			&& abs(get_global_mouse_position().y-Panel_CenterPosition.y) < SELECTION_ZONE.rect_size.y/2):
				self.modulate = Color(1,1,1,0.5)