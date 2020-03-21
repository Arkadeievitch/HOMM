extends Label
	
var Total_HP : int = 0
var Number : int = 0
var max_HP : int = 0

func _ready():
	var current_HP : int
	
	current_HP = max_HP + (Total_HP - Number*max_HP)
	self.text = str("Health points : ",current_HP," /", max_HP)
	
	if self.rect_global_position.x - get_viewport().size.x/2 < 0 :
		self.align = Label.ALIGN_LEFT
	else:
		self.align = Label.ALIGN_RIGHT