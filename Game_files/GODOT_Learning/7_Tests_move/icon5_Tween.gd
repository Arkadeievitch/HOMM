extends Sprite
#
#var mouse_pos
#onready var TweenNode = get_node("Tween")
#
#func _process(delta):
#	if Input.is_action_just_released("ui_leftclic"):
#		mouse_pos = get_global_mouse_position()
#		TweenNode.interpolate_method(self, 
#									"Transform/Pos", 
#									self.position, 
#									mouse_pos, 
#									1.0, 
#									Tween.TRANS_LINEAR, 
#									Tween.EASE_OUT)
#	pass