extends Position2D

class_name Fighter

func play_turn(target : Fighter, action):
#	yield(skin.move_forward(), "completed")
	action.execute(self, target)
#	yield(skin.move_to(target), "completed")
	yield(get_tree().create_timer(1.0), "timeout")
#	yield(skin.return_to_start(), "completed") # in example, return creature to initial position