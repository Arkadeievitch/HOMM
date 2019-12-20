extends Node

var Highest_priority : float = 0.0
var Char_number : int = 0
var Priorities = []
var Char_to_activate : int = 0
var Count_Turn_number : int = 0

var TWEENS = []
var a_tween_is_active : bool = false

var signal_1_received : bool = false
var signal_2_received : bool = false
var signal_2_counter : int = 0

signal Priorities_retrieved

func _ready():
	connect_Turn_to_signals()
	Connect_Temporary_to_Priority_signal()
	count_children_and_build_priority_array()
	update_priorities()
	activate_player_with_priority()
		
	for i in get_child_count():
		TWEENS.append(0)
		TWEENS[i] = get_child(i).get_node("Tween")
	
func _process(delta):
	for i in TWEENS.size():
		if TWEENS[i].is_active()==true:
			a_tween_is_active = true
		else:
			a_tween_is_active = false
	
	if (signal_1_received == true 
	&& signal_2_received ==true):
		signal_1_received = false 
		signal_2_received = false
		signal_2_counter = 0
		update_priorities()
		activate_player_with_priority()
		

#========================================================================
#___1___
func activate_player_with_priority():
	Highest_priority = 0
	Count_Turn_number +=1
		
	for i in Char_number:		
		if Priorities[i] > Highest_priority:
			Highest_priority = Priorities[i] 
			Char_to_activate = i
	
	get_child(Char_to_activate).active_turn = true
	
#	print("TURN ", Count_Turn_number)
#	print(Priorities)
#	print("Active : ", Char_to_activate)
#	var activation = [get_child(0).active_turn, get_child(1).active_turn, get_child(2).active_turn]
#	print(activation)
#	print("SIGNAL : Priorities")
	
	emit_signal("Priorities_retrieved")
#___2___
func update_priorities():
	for i in Char_number:
		Priorities[i] = get_child(i).get("Priority")
#___3___
func count_children_and_build_priority_array():
	Char_number = get_child_count()
	for i in Char_number:
		Priorities.append(0)
#___4___

#===SIGNALS FUNCTIONS==================================================
#___CONNECT___
func connect_Turn_to_signals():
	for i in get_child_count():
		get_child(i).connect("end_of_action", self, "on_Action_signal_in_Turn")
		get_child(i).connect("end_of_priority_calculation", self, "on_priority_signal_in_Turn")
			
#___SIG 1___
func on_Action_signal_in_Turn():
	signal_1_received = true

#___SIG 2___
func on_priority_signal_in_Turn():
	signal_2_counter +=1
	if signal_2_counter==get_child_count()-1:
		signal_2_received = true
	
	
func Connect_Temporary_to_Priority_signal():
	for i in get_child_count():
		get_child(i).get_node("Temporary").connect_Temporary_to_signals()