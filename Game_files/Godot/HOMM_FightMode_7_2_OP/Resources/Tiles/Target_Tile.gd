extends Sprite

signal movement_allowed

func _ready():
	var CHARACTER = get_parent().get_parent().get_parent()
	
	# warning-ignore:return_value_discarded
	self.connect("movement_allowed", CHARACTER, "allowing_movement")

# warning-ignore:unused_argument
func _process(delta):
	emit_signal("movement_allowed", self.global_position)
	