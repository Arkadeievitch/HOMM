extends Sprite

signal movement_allowed

func _ready():
	var TEMPORARY = get_parent().get_parent()
	var CHARACTER = get_parent().get_parent().get_parent()
	var TURN = get_node("/root/Battlefield/Turn")
	
	# warning-ignore:return_value_discarded
	self.connect("movement_allowed", CHARACTER, "allowing_movement")
	# warning-ignore:return_value_discarded
	self.connect("movement_allowed", TEMPORARY, "allowing_movement")
	# warning-ignore:return_value_discarded
	self.connect("movement_allowed", TURN, "allowing_movement")

# warning-ignore:unused_argument
func _process(delta):
	emit_signal("movement_allowed", self.global_position)
	