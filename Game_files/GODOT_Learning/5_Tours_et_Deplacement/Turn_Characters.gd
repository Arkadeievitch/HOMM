extends Node

var Highest_priority : float = 0.0
var Char_number : int = 0
var Priorities = []
var Char_to_activate : int = 0

var i : int = 0

signal Priorities_calculated

#______________________________________
func _ready():
	connect_Turn_to_signals()
	count_children_and_build_priority_array()
	activate_player_with_priority()
	print(Priorities)#

#______________________________________
func _input(event):
	if Input.is_action_just_pressed("ui_leftclic") :
		print("Turn")
		yield(get_node("/root/Battlefield"), "action_finished")
		activate_player_with_priority()
		print("Turn end")
		

#========================================================================
#______________________________________1
func activate_player_with_priority():
	Highest_priority = 0
		
	for i in Char_number:
		Priorities[i] = get_child(i).get("Priority")
		
		if Priorities[i] > Highest_priority:
			Highest_priority = Priorities[i] 
			Char_to_activate = i
	
	get_child(Char_to_activate).is_active = true
	emit_signal("Priorities_calculated")

#______________________________________2
func update_priorities():
	for i in Char_number:
		Priorities[i] = get_child(i).get("Priority")

#______________________________________3
func connect_Turn_to_signals():
	if get_node("/root/Battlefield") != null:
		self.connect("Priorities_calculated", self, "connect_Turn_to_itself")
		get_node("/root/Battlefield").connect("action_finished", self, "connect_Turn_to_Battlefield")
	
#______________________________________4
func count_children_and_build_priority_array():
	Char_number = get_child_count()
	for i in Char_number:
		Priorities.append(0)
	
