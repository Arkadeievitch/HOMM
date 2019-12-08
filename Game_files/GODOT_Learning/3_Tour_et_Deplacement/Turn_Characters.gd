extends Node

var Highest_priority : float = 0.0
var Char_number : int = 0
var Priorities = []
var Char_to_activate : int = 0

var i : int = 0

signal Priorities_calculated

#______________________________________
func _ready():
	self.connect("Priorities_calculated", self, "_input")
	Char_number = get_child_count()
	
	for i in Char_number:
		Priorities.append(0)
		
	activate_player_with_priority()
	print("ready : ", Priorities)	#
	update_priorities()
	print("ready : ", Priorities)	#
	

#______________________________________
func _input(event):
	
	if Input.is_action_just_pressed("ui_leftclic") :
		
		activate_player_with_priority()
		print("Turn2 : ", Priorities)	#


#______________________________________
func activate_player_with_priority():
	Highest_priority = 0
		
	for i in Char_number:
		Priorities[i] = get_child(i).get("Priority")
		
		if Priorities[i] > Highest_priority:
			Highest_priority = Priorities[i] 
			Char_to_activate = i
	
	get_child(Char_to_activate).is_active = true
	
	emit_signal("Priorities_calculated")
	print("signal")

#______________________________________
func update_priorities():
		
	for i in Char_number:
		Priorities[i] = get_child(i).get("Priority")