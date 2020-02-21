extends Label

func _ready():
	if get_parent().scale.x < 0:
		self.rect_scale.x = -1
		self.rect_global_position.x = get_viewport().size.x - 240
		
	if self.rect_global_position.x < get_viewport().size.x/2:
		self.text = "Player 1"
	else:
		self.text = "Player 2"