extends Label

func _ready():
	var current_HP : int
	var STATS = get_parent().get_parent()
	
	current_HP = STATS.MAX_HP + (STATS.TOTAL_HP - STATS.NUMBER*STATS.MAX_HP)
		
	self.text = str("Health points : ",current_HP," /",get_parent().get_parent().MAX_HP)
	
	if self.rect_global_position.x - get_viewport().size.x/2 < 0 :
		self.align = Label.ALIGN_LEFT
	else:
		self.align = Label.ALIGN_RIGHT