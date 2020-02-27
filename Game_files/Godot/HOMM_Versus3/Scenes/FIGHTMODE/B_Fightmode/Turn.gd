extends Node

var Highest_priority : 	float = 0.0
var Character_number : 	int = 0
var Priorities = []
var ActiveCharacter : 	int = 0

var Count_Turn_number : int = 1
var underTurn : int = 1

var MOUSE : Node
var FrontMOUSE : Node
var CHARACTERS = []
var STATS = 	 []
var TEMPORARY =  []
var TWEENS = 	 []
var IA = 		 []

var Control_oneTurn : 		bool = false
var ActiveCharacterPlayed : bool = false
var CharacterIsMoving : 	bool = false
var apply_death : 			bool = false
var FightVictory : 			bool = false

var MouseActionTarget : Vector2

func _ready():
	if has_node("/root/MainNode/SelectionMenu"):
		# warning-ignore:return_value_discarded
		get_node("/root/MainNode/SelectionMenu").connect("tree_exited", self, "initialize")

func initialize():
	print("--- Turn ", Count_Turn_number, " (", underTurn, ") ---")
	retrieveNodes()
	connectSelf()
	retrievePriorities()
	print(Priorities)
	activatePlayer()
	
	# Déclenche le tour si le premier joueur actif est une IA.
	for i in Character_number:
		if CHARACTERS[i].active_turn == true:
			print(STATS[i].NAME, " is going to play")
			if STATS[i].IA == true:
				MOUSE.emit_signal("mouse_clic", MOUSE.Action_Position, MOUSE.Tile_position)

#==============================================================
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _TURN_MainFunction(Mouse_ActionTarget, Mouse_TileTarget):
	
	MouseActionTarget = Mouse_ActionTarget  # Permet uniquement de passer la position
											# dans une variable globale 
											#(notamment pour les tweens de projectiles)
	
	if Control_oneTurn == false && FightVictory == false:
		Control_oneTurn = true
		
		ActiveCharacterPlayed = false
		CharacterIsMoving = false
		
		var Dead_index : int = 0
		apply_death = false
		
		# 1 / Active player
		for i in Character_number:
			if CHARACTERS[i].active_turn == true:
				if STATS[i].IA == true:
					var IA_result = IA[i].IA()
					Mouse_ActionTarget = IA_result[1]
					Mouse_TileTarget = 	 IA_result[0]
					
				TEMPORARY[i].deleteDisplacementTiles()
				CHARACTERS[i]._PlayAction(Mouse_TileTarget, Mouse_ActionTarget)
				if CharacterIsMoving == true:
					yield(TWEENS[i],"tween_completed")
					CharacterIsMoving = false
	
		if ActiveCharacterPlayed == true:
			# 2 / Inactive players
			for i in Character_number:
				if CHARACTERS[i].active_turn == false:
					CHARACTERS[i]._PassiveAction(Mouse_ActionTarget)
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
			print(Priorities)
			PrepareNextTurn()
		else:
			activatePlayer()

		Control_oneTurn = false
		
	retrieveNodes()
	if FightVictory == false:
		for i in Character_number:
			if CHARACTERS[i].active_turn == true:
				print(STATS[i].NAME, " is going to play")
				if STATS[i].IA == true:
					MOUSE.emit_signal("mouse_clic", MOUSE.Action_Position, MOUSE.Tile_position)
#==============================================================

func retrieveNodes():
	MOUSE = get_node("/root/MainNode/Battlefield/Mouse_Cursor")
	FrontMOUSE  = get_node("/root/MainNode/Battlefield/Mouse_Cursor/Mouse_Front")
	
	CHARACTERS = []
	CHARACTERS = get_children()
	Character_number = get_child_count()
	
	TWEENS = 	[]
	TEMPORARY = []
	STATS = 	[]
	for i in Character_number:
		TEMPORARY.append(0)
		TEMPORARY[i] = CHARACTERS[i].get_node("Temporary")
		IA.append(0)
		IA[i] = CHARACTERS[i].get_node("IA")
		STATS.append(0)
		STATS[i] = CHARACTERS[i].get_node("icon/Stats")
		TWEENS.append(0)
		TWEENS[i] = get_child(i).get_node("Tween")

func connectSelf():
	# warning-ignore:return_value_discarded
	MOUSE.connect("mouse_clic", self, "_TURN_MainFunction")
	
	for i in get_child_count():
		TWEENS[i].connect("tween_completed", self, "Nothing")

func retrievePriorities():
	Priorities = []
	for i in Character_number:
		Priorities.append(0)
		Priorities[i] = get_child(i).get("Priority")

func activatePlayer():
	Highest_priority = 0
	if Character_number > 1:
		for i in Character_number:
			if Priorities[i] > Highest_priority:
				Highest_priority = Priorities[i] 
				ActiveCharacter = i
	else:
		ActiveCharacter = 0
	
	get_child(ActiveCharacter).active_turn = true
	get_child(ActiveCharacter).get_node("Temporary").drawDisplacementTiles()
	FrontMOUSE.Current_Side = get_child(ActiveCharacter).get_node("icon/Stats").SIDE
	updateTurnChronology()
	
func updateTurnChronology():
	var CHRONO = get_node("/root/MainNode/Battlefield/UI/BottomMenu/Chronology")
	CHRONO.updateChronology(Priorities)
	retrievePriorities() # Bizarrerie : la fonction update Chronology édite la valeur de Priorities
						 # malgré son passage en argument et son stockage dans une variable intermédiaire...

func PrepareNextTurn():
	underTurn = (underTurn+ 1) % Character_number
	if underTurn == 1:
		Count_Turn_number += 1
		var TurnLabel = get_parent().get_node("UI/BottomMenu/Label_Turn")
		TurnLabel.text = str(" Turn ", Count_Turn_number)
	print(" ")
	print("--- Turn ", Count_Turn_number, " (Unit ", underTurn, ") ---")
	retrieveNodes()
	retrievePriorities()
	activatePlayer()
	Victory()

func ApplyDeath(Dead_index):
	Character_number -=1
	CHARACTERS.remove(Dead_index)
	STATS.remove(Dead_index)
	TWEENS.remove(Dead_index)
	Priorities.remove(Dead_index)
	MOUSE.get_node("Mouse_Front").Character_number -=1
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
		FightVictory = true
		
		get_parent().get_parent().load_Victory_Screen(Winner)

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func Nothing(a,b):
	print("Tween completed")