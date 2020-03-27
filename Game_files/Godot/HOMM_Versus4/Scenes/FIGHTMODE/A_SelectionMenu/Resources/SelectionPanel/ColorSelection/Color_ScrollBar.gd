extends HScrollBar

var former_value
var COLOR_NODE2

func _ready():
	if has_node("/root/MainNode/SelectionMenu/"):
		if get_parent().name =="Table_Player1":
			COLOR_NODE2 = get_node("/root/MainNode/SelectionMenu/Table_Player2/Color_ScrollBar")
		else:
			COLOR_NODE2 = get_node("/root/MainNode/SelectionMenu/Table_Player1/Color_ScrollBar")
	if get_parent().has_node("Heroes"):
		if get_parent().scale.x < 0:
			self.rect_scale.x = -1
			self.rect_global_position.x = get_parent().global_position.x-192
			
		if self.rect_global_position.x > get_viewport().size.x/2:
			self.value = 2
	former_value = self.value

# warning-ignore:unused_argument
func _input(event):
	if Input.is_action_just_released("ui_leftclic"):
		if (abs(COLOR_NODE2.value - self.value) < 0.5 && (self.value-former_value)>.5):
			self.value += 1
		elif (abs(COLOR_NODE2.value - self.value) < 0.5 && (self.value-former_value)<-0.5):
			self.value -= 1
		former_value = self.value