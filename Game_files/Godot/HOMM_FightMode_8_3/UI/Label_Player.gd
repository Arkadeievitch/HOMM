extends Label

func _ready():
	# warning-ignore:return_value_discarded
	get_parent().connect("value_changed", self, "changePlayer")
	self.text = "Player 1"

func changePlayer(float_value):
	if abs(float_value - 1) < .01:
		self.text = "Player 1"
	elif float_value - 1 > 0.1 :
		self.text = "Player 2"
	else:
		self.text = "No Player"