extends Label

func _ready():
	if self.rect_global_position.x < 700:
		self.text = "Player 1"
	else:
		self.text = "Player 2"