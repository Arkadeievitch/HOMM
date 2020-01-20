extends Node

var Highest_priority : 	float = 0.0
var Character_number : 	int = 0
var Priorities = []
var ActiveCharacter : 	int = 0
var Count_Turn_number : int = 1

var TWEENS = []
#var a_tween_is_active : bool = false

var MOUSE : Node
var TIMER : Node
var CHARACTERS
var STATS = []
var TEMPORARY = []

var Control_oneTurn : bool = false
var ActiveCharacterPlayed : bool = false
var CharacterIsMoving : bool = false
var apply_death : bool = false
	

#var all_char_signals_received : bool = false
#var signal_counter : int = 0

#var pass_turn : bool = false

#signal Priorities_retrieved
#signal death_accounted

func _ready():
	print("--- Turn ", Count_Turn_number, " ---")
	retrieveNodes()
	retrieveTweens()
	connectSelf()
	retrievePriorities()
	activatePlayer()

#==============================================================
func _TURN_MainFunction(Mouse_ActionTarget, Mouse_TileTarget):
	if Control_oneTurn == false:
		Control_oneTurn = true
		
		ActiveCharacterPlayed = false
		CharacterIsMoving = false
		
		var Dead_index : int = 0
		apply_death = false
		print("NewTurn")
		
		# 1 / Active player
		for i in Character_number:
			TEMPORARY[i].deleteDisplacementTiles()
			if CHARACTERS[i].active_turn == true:
				CHARACTERS[i]._PlayAction(Mouse_ActionTarget, Mouse_TileTarget)
				if CharacterIsMoving == true:
					yield(TWEENS[i],"tween_completed")
					CharacterIsMoving = false
				
		if ActiveCharacterPlayed == true:
			# 2 / Inactive players
			for i in Character_number:
				if CHARACTERS[i].active_turn == false:
					CHARACTERS[i]._PassiveAction(Mouse_ActionTarget, Mouse_TileTarget)
					if STATS[i].NUMBER == 0 :
						Dead_index = i
						print(STATS[i].NAME, " is dead")
						CHARACTERS[i].queue_free()
						apply_death = true
				
			if apply_death == true:
				ApplyDeath(Dead_index)
			
			# 3 / End active player turn
			for i in Character_number:
				if CHARACTERS[i].active_turn == true:
					CHARACTERS[i].endAction()
			
			yield(get_tree(), "idle_frame")
			PrepareNextTurn()
			print(Priorities)
		else:
			activatePlayer()
		
		Control_oneTurn = false
#==============================================================

func retrieveNodes():
	MOUSE = get_node("/root/Battlefield/Mouse/Mouse_Cursor")
	TIMER = get_node("/root/Battlefield/Timer")
	
	CHARACTERS = []
	CHARACTERS = get_children()
	Character_number = get_child_count()
	
	TEMPORARY = []
	STATS = []
	for i in Character_number:
		TEMPORARY.append(0)
		TEMPORARY[i] = CHARACTERS[i].get_node("Temporary")
		STATS.append(0)
		STATS[i] = CHARACTERS[i].get_node("icon/Stats")

func retrieveTweens():
	TWEENS = []
	for i in get_child_count():
		TWEENS.append(0)
		TWEENS[i] = get_child(i).get_node("Tween")

func connectSelf():
	# warning-ignore:return_value_discarded
	MOUSE.connect("mouse_clic", self, "_TURN_MainFunction")
	
	for i in get_child_count():
		TWEENS[i].connect("tween_completed", self, "Nothing")
#		CHARACTERS[i].connect("tree_exited", self, "")

func retrievePriorities():
	Priorities = []
	for i in Character_number:
		Priorities.append(0)
		Priorities[i] = get_child(i).get("Priority")

func activatePlayer():
	Highest_priority = 0
	if Character_number >1:
		for i in Character_number:		
			if Priorities[i] > Highest_priority:
				Highest_priority = Priorities[i] 
				ActiveCharacter = i
	else:
		ActiveCharacter = 0
	
	get_child(ActiveCharacter).active_turn = true
	get_child(ActiveCharacter).get_node("Temporary").drawDisplacementTiles()
	
func PrepareNextTurn():
	Count_Turn_number += 1
	print("--- Turn ", Count_Turn_number, " ---")
	retrieveNodes()
	retrieveTweens()
	retrievePriorities()
	activatePlayer()
	Victory()

func ApplyDeath(Dead_index):
	Character_number -=1
	CHARACTERS.remove(Dead_index)
	STATS.remove(Dead_index)
	TWEENS.remove(Dead_index)
	Priorities.remove(Dead_index)
	apply_death = false
	

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
		
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func Nothing(a,b):
	pass