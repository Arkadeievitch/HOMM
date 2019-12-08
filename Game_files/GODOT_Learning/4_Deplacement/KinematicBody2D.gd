extends KinematicBody2D
var velocity = Vector2()

var Current_X : int = self.global_position.x
var Current_Y : int = self.global_position.y
var Target_X : int = -10
var Target_Y : int = -10

func _process(delta):
	var speed : int = 5
	if Input.is_action_just_pressed("ui_leftclic"):
		
		Current_X = self.global_position.x
		Current_Y = self.global_position.y
		Target_X = round(get_global_mouse_position().x /24 ) * 24
		Target_Y = round(get_global_mouse_position().y /24 ) * 24
		
		velocity.x = speed * (Target_X - Current_X)
		velocity.y = speed * (Target_Y - Current_Y)
		
	if abs(self.global_position.x - Target_X) <= 5:
		velocity.x = 0
		velocity.y = 0
	else:
		move_and_slide(velocity)