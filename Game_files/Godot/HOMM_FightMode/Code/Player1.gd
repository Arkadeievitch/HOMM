extends KinematicBody2D
# ONLY WORKS WITH KINEMATICS
#__________________________________________________________________________
# Move the player at the clicked position
export (int) var speed = 0

var target = Vector2()
var velocity = Vector2()

func _input(event):
	if event.is_action_pressed('ui_leftclick'):
		target = Vector2(get_global_mouse_position().x-32, get_global_mouse_position().y+32)
		speed = 400


func _physics_process(delta):
	velocity = (target - position).normalized() * speed
#    # rotation = velocity.angle()
	if (target - position).length() > 5:
        velocity = move_and_slide(velocity)
#__________________________________________________________________________