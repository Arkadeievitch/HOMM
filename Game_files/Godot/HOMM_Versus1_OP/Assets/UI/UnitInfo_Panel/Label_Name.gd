extends Label

func _ready():
	self.text = str(get_parent().get_parent().NAME)
	
	if self.rect_global_position.x - get_viewport().size.x/2 < 0 :
		self.align = Label.ALIGN_LEFT
	else:
		self.align = Label.ALIGN_RIGHT