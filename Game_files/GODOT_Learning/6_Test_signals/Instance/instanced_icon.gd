extends Sprite


signal is_sent_by_instance

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("is_sent_by_instance")
		print("instanced signal sent")