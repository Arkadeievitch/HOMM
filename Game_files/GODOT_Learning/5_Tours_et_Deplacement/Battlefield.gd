extends Node2D

var wait_for_action : bool = false
signal action_finished

func _input(event):
	if Input.is_action_just_pressed("ui_leftclic"):
		print("Battlefield")
		wait_for_action = true
		
func _process(delta):
	if wait_for_action == false:
		emit_signal("action_finished")
		