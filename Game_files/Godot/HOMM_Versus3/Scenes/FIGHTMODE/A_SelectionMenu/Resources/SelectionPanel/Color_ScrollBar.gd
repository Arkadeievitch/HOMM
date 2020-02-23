extends HScrollBar

func _ready():
	if get_parent().scale.x < 0:
		self.rect_scale.x = -1
		self.rect_global_position.x = get_parent().global_position.x-192
		
	if self.rect_global_position.x > get_viewport().size.x/2:
		self.value = 2