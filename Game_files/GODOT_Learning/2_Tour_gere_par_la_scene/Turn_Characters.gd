extends Node

var Highest_priority : float = 0.0
var Char_number : int = 0
var Priorities = []
var Char_to_activate : int = 0

var i : int = 0

signal Priorities_calculated

func _ready():
	Char_number = get_child_count()
	
	for i in Char_number:
		Priorities.append(0)
		Priorities[i] = get_child(i).get("Priority")
	

func _input(event):
	
	if Input.is_action_pressed("ui_leftclic") :
		
		Highest_priority = 0
		
		for i in Char_number:
			Priorities[i] = get_child(i).get("Priority")
			
			if Priorities[i] > Highest_priority:
				Highest_priority = Priorities[i] 
				Char_to_activate = i
			
#		print("Start --- ", Priorities) 		#
		get_child(Char_to_activate).is_active = true
		
		emit_signal("Priorities_calculated")
			
#		print("Last player : ", Char_to_activate)	#
#		print("_") 		#
		