extends CheckButton

func _ready():
	if get_parent().scale.x < 0:
		self.rect_scale.x = -1
		self.rect_global_position.x = get_viewport().size.x - 460