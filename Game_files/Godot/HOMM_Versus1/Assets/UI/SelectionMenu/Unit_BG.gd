extends ColorRect

func _ready():
	var TABLE = get_parent().get_parent().get_parent().get_parent()
	if  TABLE != null:
		var SCROLL = TABLE.get_node("Player_ScrollBar")
		SCROLL.connect("value_changed", self, "changeColor")
		changeColor(SCROLL.value)

func changeColor(float_value):
	if abs(float_value - 1) < .01:
		self.color = Color(.2, .3, .8, 1)
	elif float_value - 1 > 0.1 :
		self.color = Color(.8, .25, .25, 1)
	else:
		self.color = Color(1, 1, 1, 1)