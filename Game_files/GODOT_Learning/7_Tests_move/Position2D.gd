extends KinematicBody2D
#
#var Current_X
#var Current_Y
#var Target_X
#var Target_Y
#
#var velocity : Vector2
#var is_active : bool = false
#
#var ROOT
#
#
#func _ready():
#	Current_X = int(self.global_position.x)
#	Current_Y = int(self.global_position.y)
#	ROOT = get_parent()
#	print(Current_X, ", ", Current_Y)
#
#func _input(event):
#	if Input.is_action_just_pressed("ui_leftclic"):
#		is_active = true
#		set_velocity()
#		print(velocity)
#
#
#func _process(delta):
#	if is_active==true:
#		if abs(self.global_position.x - Target_X) <= 12:
#			end_displacement()
#			print("end")
#		else:
#			displacement()
#
##========================================================
##___1___
#func set_velocity():
#	var speed : int = 5
#
#	Current_X = int(self.global_position.x)
#	Current_Y = int(self.global_position.y)
#	Target_X = int(round(get_global_mouse_position().x /24 ) * 24)
#	Target_Y = int(round(get_global_mouse_position().y /24 ) * 24)
#
#	velocity.x = speed * (Target_X - Current_X)
#	velocity.y = speed * (Target_Y - Current_Y)
##___2___
#func displacement():
#	move_and_slide(velocity)
##___3___
#func end_displacement():
#		velocity.x = 0
#		velocity.y = 0
#		is_active = false
#		ROOT.signal_emission()
#
#func on_signal_call():
#	pass
#
#func connect_signal():
#	get_parent().connect("end_of_displacement", self, "on_signal_call")
#