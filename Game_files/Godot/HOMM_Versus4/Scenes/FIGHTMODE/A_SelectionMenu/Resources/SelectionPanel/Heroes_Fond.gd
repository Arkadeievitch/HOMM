extends Sprite

var ChosenColor

func _ready():
	
	if get_parent().rect_global_position.x < get_viewport().size.x/2:
		pass
	else:
		self.global_position.x = self.global_position.x-4
	
	if  has_node("/root/MainNode/SelectionMenu/") == true:
		var SCROLLBAR = get_parent().get_parent().get_node("Color_ScrollBar")
		SCROLLBAR.connect("value_changed", self, "changeColor")
		changeColor(SCROLLBAR.value)

func changeColor(float_value):
	if abs(float_value - 1) < .01: # Blue
		self.modulate = 	Color(.25, .25, .8, 1)
		ChosenColor = 	Color(.25, .25, .8, 1)
	elif abs(float_value - 2) < .01: # Red
		self.modulate = 	Color(.8, .25, .25, 1)
		ChosenColor = 	Color(.8, .25, .25, 1)
	elif abs(float_value - 3) < .01: # Green
		self.modulate = 	Color(.25, .8, .25, 1)
		ChosenColor = 	Color(.25, .8, .25, 1)
	elif abs(float_value - 4) < .01: # Yellow
		self.modulate = 	Color(.8, .8, .25, 1)
		ChosenColor = 	Color(.8, .8, .25, 1)
	elif abs(float_value - 5) < .01: # Pink
		self.modulate = 	Color(.8, .25, .8, 1)
		ChosenColor = 	Color(.8, .25, .8, 1)
	elif abs(float_value - 6) < .01: # Cyan
		self.modulate = 	Color(.25, .8, .8, 1)
		ChosenColor = 	Color(.25, .8, .8, 1)
	elif abs(float_value - 7) < .01: # Purple
		self.modulate = 	Color(.4, 0, .4, 1)
		ChosenColor = 	Color(.4, 0, .4, 1)
	elif abs(float_value - 7.6) < .01: # Orange
		self.modulate = 	Color(.7, .5, 0, 1)
		ChosenColor = 	Color(.7, .5, 0, 1)
	else:
		self.modulate = 	Color(1, 1, 1, 1)
		ChosenColor = 	Color(1, 1, 1, 1)

