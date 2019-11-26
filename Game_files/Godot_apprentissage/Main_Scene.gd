extends Node2D

var Highest_priority : float = 0.0
var Char_number : int

func _ready():
	Char_number = get_child_count()

func _input(event):
	var i : int = 0
	
	if Input.is_action_pressed("ui_leftclic") or Input.is_action_pressed("ui_accept"):
		
		if Char_number > 0:
			
			var measured_priority : float
			
			for i in Char_number:
				measured_priority = get_child(i).get("Priority")
				if i == 0:
					Highest_priority = measured_priority
				else:
					if Highest_priority < measured_priority:
						Highest_priority = measured_priority