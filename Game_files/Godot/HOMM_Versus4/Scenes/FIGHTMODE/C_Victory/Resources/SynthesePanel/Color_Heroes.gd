extends ColorRect

var ChosenColor

func _ready():
	if  (has_node("/root/MainNode/SelectionMenu/") == true 
	|| has_node("/root/Table_Player/") == true):
		var SCROLLBAR = get_parent().get_parent().get_node("Color_ScrollBar")
		SCROLLBAR.connect("value_changed", self, "changeColor")
	self.visible = false

func changeColor(float_value):
	self.visible = true
	if abs(float_value - 1) < .01: # Blue
		self.color = 	Color(.25, .25, .8, 1)
		ChosenColor = 	Color(.25, .25, .8, 1)
	elif abs(float_value - 2) < .01: # Red
		self.color = 	Color(.8, .25, .25, 1)
		ChosenColor = 	Color(.8, .25, .25, 1)
	elif abs(float_value - 3) < .01: # Green
		self.color = 	Color(.25, .8, .25, 1)
		ChosenColor = 	Color(.25, .8, .25, 1)
	elif abs(float_value - 4) < .01: # Yellow
		self.color = 	Color(.8, .8, .25, 1)
		ChosenColor = 	Color(.8, .8, .25, 1)
	elif abs(float_value - 5) < .01: # Pink
		self.color = 	Color(.8, .25, .8, 1)
		ChosenColor = 	Color(.8, .25, .8, 1)
	elif abs(float_value - 6) < .01: # Cyan
		self.color = 	Color(.25, .8, .8, 1)
		ChosenColor = 	Color(.25, .8, .8, 1)
	elif abs(float_value - 7) < .01: # Purple
		self.color = 	Color(.4, 0, .4, 1)
		ChosenColor = 	Color(.4, 0, .4, 1)
	elif abs(float_value - 7.6) < .01: # Orange
		self.color = 	Color(.7, .5, 0, 1)
		ChosenColor = 	Color(.7, .5, 0, 1)
	else:
		self.color = 	Color(1, 1, 1, 1)
		ChosenColor = 	Color(1, 1, 1, 1)