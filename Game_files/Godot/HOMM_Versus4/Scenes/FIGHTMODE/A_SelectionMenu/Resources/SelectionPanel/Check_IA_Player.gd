extends CheckButton

func _ready():
	if self.rect_global_position.x > get_viewport().size.x/2:
		self.rect_scale.x = -1
		self.rect_global_position.x -= 96+80