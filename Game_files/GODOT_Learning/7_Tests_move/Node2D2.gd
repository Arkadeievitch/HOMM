extends Node2D

var mouse_pos
onready var TweenNode = get_node("Tween")

func _ready():
	set_process(true)

func _process(delta):
	
	if Input.is_action_just_pressed("ui_rightclic"):
		print("right clic")
		mouse_pos = get_global_mouse_position()
		TweenNode.interpolate_property(self, 
									"position", 
									self.global_position, 
									mouse_pos, 
									0.1, 
									Tween.TRANS_LINEAR, 
									Tween.EASE_OUT)
		TweenNode.start()
	
	if TweenNode.is_active() ==true:
		print("active")
	