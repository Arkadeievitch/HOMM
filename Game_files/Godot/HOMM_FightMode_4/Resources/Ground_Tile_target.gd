extends Sprite

signal movement_allowed

func _ready():
	# connect Character to self
	# warning-ignore:return_value_discarded
	self.connect("movement_allowed", get_parent().get_parent().get_parent(), "allowing_movement")
	# connect Temporary to self
	# warning-ignore:return_value_discarded
	self.connect("movement_allowed", get_parent().get_parent(), "allowing_movement")
	# connect Turn to self
	# warning-ignore:return_value_discarded
	self.connect("movement_allowed", get_node("/root/Battlefield/Turn"), "allowing_movement")

# warning-ignore:unused_argument
func _process(delta):
	emit_signal("movement_allowed", self.global_position)