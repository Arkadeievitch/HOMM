extends Sprite

signal is_sent

func _init():
	
	pass

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		print("signal sent")
		emit_signal("is_sent")
		print("signal sent")