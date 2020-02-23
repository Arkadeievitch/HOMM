extends Label

func _ready():
	if get_parent().get_parent().scale.x < 0:
		self.rect_global_position.x = get_viewport().size.x - 276
		
# warning-ignore:unused_argument
func _input(event):
	if Input.is_action_just_pressed("ui_leftclic"):
		var HEROES = get_parent().get_parent().get_node("Heroes")
		if HEROES.get_child_count()>0:
			self.text = ""