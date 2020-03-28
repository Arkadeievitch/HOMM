extends Sprite

signal movement_allowed

func _ready():
	var CHARACTER = get_parent().get_parent().get_parent()
	var TURN = get_node("/root/MainNode/Battlefield/Turn")
	var MOUSE = get_node("/root/MainNode/Battlefield/Mouse_Cursor")
	var MACARON = get_node("/root/MainNode/Battlefield/UI/BottomMenu/Macaron")
	
	# warning-ignore:return_value_discarded
	self.connect("movement_allowed", TURN, "allowing_movement")
	# warning-ignore:return_value_discarded
	self.connect("movement_allowed", CHARACTER, "allowing_movement")
	# warning-ignore:return_value_discarded
	self.connect("movement_allowed", MOUSE, "Target_Tile")
	# warning-ignore:return_value_discarded
	self.connect("movement_allowed", MACARON, "Target_Tile")
	
	MOUSE.Tile_position = self.global_position
	if (get_parent().modulate[0] - 0.25 < 0.05
	&& get_parent().modulate[1] - 0.8 < 0.05
	&& get_parent().modulate[2] - 0.25 < 0.05
	&& get_parent().modulate[3] - 0.9 < 0.05):
		self.modulate = Color(0,0,1,1)
	else:
		self.modulate = Color(0,1,0,1)

# warning-ignore:unused_argument
func _process(delta):
	emit_signal("movement_allowed", self.global_position)