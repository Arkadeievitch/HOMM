extends Sprite

signal movement_allowed

func _ready():
	var CHARACTER = get_parent().get_parent().get_parent()
	var TURN = get_node("/root/MainNode/Battlefield/Turn")
	var MOUSE = get_node("/root/MainNode/Battlefield/Mouse_Cursor")
	
	# warning-ignore:return_value_discarded
	self.connect("movement_allowed", TURN, "allowing_movement")
	# warning-ignore:return_value_discarded
	self.connect("movement_allowed", CHARACTER, "allowing_movement")
	# warning-ignore:return_value_discarded
	self.connect("movement_allowed", MOUSE, "Target_Tile")
	
	MOUSE.Tile_position = self.global_position

# warning-ignore:unused_argument
func _process(delta):
	emit_signal("movement_allowed", self.global_position)