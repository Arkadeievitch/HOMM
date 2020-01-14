extends Node

var Highest_priority : 	float = 0.0
var Char_number : 		int = 0
var Priorities = []
var Char_to_activate : 	int = 0
var Count_Turn_number : int = 0

var TWEENS = []
var a_tween_is_active : bool = false

var signal_1_received : bool = false
var signal_2_received : bool = false
var signal_2_counter : int = 0

var pass_turn : bool = false

signal Priorities_retrieved
signal death_accounted

func _ready():
	ConnectSelf()
	Connect_Temporary_to_Priority_signal()
	count_children_and_build_priority_array()
	retrieve_priorities()
	activate_player_with_priority()
	emit_signal("Priorities_retrieved")
		
	for i in get_child_count():
		TWEENS.append(0)
		TWEENS[i] = get_child(i).get_node("Tween")
	
# warning-ignore:unused_argument
func _process(delta):
	retrieveTweens()
	for i in TWEENS.size():
		if TWEENS[i].is_active() == true:
			a_tween_is_active = true
		else:
			a_tween_is_active = false
	
	if (signal_1_received == true 
	&&  signal_2_received == true
	&&  pass_turn == true):
		
		signal_1_received = false 
		signal_2_received = false
		signal_2_counter = 0
		Victory()
		retrieve_priorities()
		activate_player_with_priority()
#		print("Priorities retrieved")###
		emit_signal("Priorities_retrieved")
		
#========================================================================
func activate_player_with_priority():
	Highest_priority = 0
	Count_Turn_number +=1
		
	for i in Char_number:		
		if Priorities[i] > Highest_priority:
			Highest_priority = Priorities[i] 
			Char_to_activate = i
	
	get_child(Char_to_activate).active_turn = true
	
func retrieve_priorities():
	for i in Char_number:
		Priorities[i] = get_child(i).get("Priority")

func count_children_and_build_priority_array():
	Char_number = get_child_count()
	for i in Char_number:
		Priorities.append(0)

func retrieveTweens():
	TWEENS = []
	for i in get_child_count():
		TWEENS.append(0)
		TWEENS[i] = get_child(i).get_node("Tween")

func Victory():
	var Player_in_each_side = [0, 0, 0]
	var Victory_condition : int = 0
	var Winner
	
	for i in get_child_count():
		if get_child(i).get_node("icon/Stats").SIDE == 1:
			Player_in_each_side[0] +=1
		elif get_child(i).get_node("icon/Stats").SIDE == 2:
			Player_in_each_side[1] +=1
		else:
			Player_in_each_side[2] +=1
			
	for i in Player_in_each_side.size():
		if Player_in_each_side[i] == 0:
			Victory_condition += 1
			
	if Victory_condition == 2:
		for i in Player_in_each_side.size():
			if Player_in_each_side[i] > 0:
				Winner = i+1
		print("Player ", Winner," VICTORY")

#===SIGNALS FUNCTIONS==================================================
#___CONNECT___
func ConnectSelf():
	for i in get_child_count():
		# warning-ignore:return_value_discarded
		get_child(i).connect("end_of_action", self, "on_Action_signal_in_Turn")
		# warning-ignore:return_value_discarded
		get_child(i).connect("end_of_priority_calculation", self, "on_priority_signal_in_Turn")
		# warning-ignore:return_value_discarded
		get_child(i).connect("dead_character", self, "on_Death")

func Connect_Temporary_to_Priority_signal():
	for i in get_child_count():
		get_child(i).get_node("Temporary").connect_Temporary_to_signals()
		
func on_Action_signal_in_Turn():
	signal_1_received = true

func on_priority_signal_in_Turn():
	signal_2_counter +=1
	if signal_2_counter==get_child_count()-1:
		signal_2_received = true
		
# warning-ignore:unused_argument
func allowing_movement(Target_tile_position):
	pass_turn = true

func on_Death():
	yield(get_tree(),"idle_frame")
	retrieveTweens()
	count_children_and_build_priority_array()
	retrieve_priorities()
	Victory()
	emit_signal("death_accounted")
	