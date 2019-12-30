extends Sprite

signal movement_allowed

func _ready():
	# warning-ignore:return_value_discarded
	self.connect("movement_allowed", get_parent().get_parent().get_parent(), "allowing_movement")
	# warning-ignore:return_value_discarded
	self.connect("movement_allowed", get_parent().get_parent(), "allowing_movement")

# warning-ignore:unused_argument
func _process(delta):
	emit_signal("movement_allowed", self.global_position)