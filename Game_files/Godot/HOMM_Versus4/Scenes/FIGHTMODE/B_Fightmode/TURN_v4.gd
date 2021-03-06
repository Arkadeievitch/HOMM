extends Node

var DamagePopup_path = "res://Scenes/FIGHTMODE/B_Fightmode/Resources/DamagePopup/DamagePopup.tscn"
var Disp_Tiles_path = "res://Scenes/FIGHTMODE/B_Fightmode/Resources/Temporary_Tiles/Ground_Tiles.tscn"
var Ranged_Tile_path = "res://Scenes/FIGHTMODE/B_Fightmode/Resources/Temporary_Tiles/Ranged_Tile.tscn"
var Active_Border_path = "res://Scenes/FIGHTMODE/B_Fightmode/Resources/Active_Border/Active_Border.tscn"

var Highest_priority : 	float = 0.0
var Character_number : 	int = 0
var Priorities = []
var ActiveCharacter_index : 	int = 0

var Count_Turn_number : int = 1
var underTurn : 		int = 1

var MAIN : 		 Node
var MOUSE : 	 Node
var FrontMOUSE : Node
var CHARACTERS = []
var STATS = 	 []
var TEMPORARY =  []
var TWEEN = 	 Node
var TIMER : 	 Node
var MACARON : 	 Node

var Control_oneTurn : 		bool = false
var ActiveCharacterPlayed : bool = false
var CharacterIsMoving : 	bool = false
var apply_death : 			bool = false
var FightVictory : 			bool = false

# Battlefield limits
var X_lowerLimit : int
var X_upperLimit : int
var Y_lowerLimit : int
var Y_upperLimit : int

# === Characters data ===
# ---- STATS ----
var NAME  		= []

var SIDE 		= []
var FACTION 	= []
var RANGED 		= []
var ARROW  		= []

var NUMBER  		= []
var DAMAGE  		= []
var DISPLACEMENT 	= []
var INITIATIVE	 	= []
var MAX_HP 			= []
var TOTAL_HP 		= []
# ---- STATS ----

# var displacement_allowed : bool = false
var Active_turn 			= []
var COUNTERSTRIKE_READY 	= []
var COUNTERSTRIKE_ALLOWED 	= []
# === Characters data ===

var MouseActionTarget : Vector2
var TargetTile_Position : Vector2

# Victory utilitaries ---
#var Resurection_score : int

func _ready():
	# Battlefield limits
	var FIELD_LIMITS = get_parent().get_node("UI/Battlefield_Limits")
	X_lowerLimit = FIELD_LIMITS.rect_global_position.x
	X_upperLimit = FIELD_LIMITS.rect_global_position.x + FIELD_LIMITS.rect_size.x
	Y_lowerLimit = FIELD_LIMITS.rect_global_position.y
	Y_upperLimit = FIELD_LIMITS.rect_global_position.y + FIELD_LIMITS.rect_size.y
	
	if has_node("/root/MainNode/SelectionMenu"):
		# warning-ignore:return_value_discarded
		get_node("/root/MainNode/SelectionMenu").connect("tree_exited", self, "initialize")
	
	yield(get_tree(), "idle_frame")
	for i in Character_number:
		STATS[i].panel_position()

func initialize(): # Attend la fermeture du menu pour démarrer
	print("--- Turn ", Count_Turn_number, " (Unit ", underTurn, "/", Character_number, ") ---")
	retrieveNodes()
	
	# warning-ignore:return_value_discarded
	MOUSE.connect("mouse_clic", self, "_TURN_MainFunction")
	# warning-ignore:return_value_discarded
	TWEEN.connect("tween_completed", self, "NothingTWEEN")
	# warning-ignore:return_value_discarded
	TIMER.connect("timeout", self, "NothingTIMER")	
	
	for i in Character_number:
		CHARACTERS[i].get_node("icon")._ready()
		
		if STATS[i].SIDE == 1:
			get_parent().get_parent().IDs_1.append(CHARACTERS[i])
		elif STATS[i].SIDE == 2:
			get_parent().get_parent().IDs_2.append(CHARACTERS[i])
			
	get_parent().get_parent().updateFightInformation()
	
	get_parent().init_HuntingBoard()
	retrieveStats()
	print(Priorities)
	activatePlayer()
	
	# Déclenche le tour si le premier joueur actif est une IA.
	for i in Character_number:
		if Active_turn[i] == true:
			print(STATS[i].NAME, " is going to play")
#			if STATS[i].IA == true:
#				MOUSE.emit_signal("mouse_clic", MOUSE.Action_Position, MOUSE.Tile_position)

#==============================================================
func _TURN_MainFunction(Mouse_ActionTarget, Mouse_TileTarget):
	MACARON.Ranged_playing = false
	MOUSE.Mouse_Inhibition = true
	MouseActionTarget = Mouse_ActionTarget  # Permet uniquement de passer la position
											# dans une variable globale 
											# (notamment pour le(s) tween(s) de projectiles)
	
	if Control_oneTurn == false && FightVictory == false:
		Control_oneTurn = true
		
		ActiveCharacterPlayed = false
		CharacterIsMoving = false
		
		var Dead_index = []
		apply_death = false
		
		# 1 / Active player
		for i in Character_number:
			if Active_turn[i] == true:
				# if STATS[i].IA == true:
					# var IA_result = IA[i].IA()
					# Mouse_ActionTarget =  IA_result[1]
					# Mouse_TileTarget = 	IA_result[0]
				
				TEMPORARY[i].deleteDisplacementTiles()
				_PlayAction(CHARACTERS[i], Mouse_TileTarget, Mouse_ActionTarget)
				if CharacterIsMoving == true:
					yield(TWEEN,"tween_completed")
					CharacterIsMoving = false
					# Si deplacement + attaque (sinon, animation dans _PlayAction)
					if not Mouse_TileTarget == Mouse_ActionTarget:
						CHARACTERS[i].ANIM_MeleeAttack(Mouse_ActionTarget)
						TIMER.start(0.5)
						yield(TIMER, "timeout")
		
		if ActiveCharacterPlayed == true:
			# 2 / Inactive players
			for i in Character_number:
				if Active_turn[i] == false:
					_PassiveAction(Mouse_ActionTarget, Mouse_TileTarget, i)
			
			# 3 / End active player turn
			for i in Character_number:
				if Active_turn[i] == true:
					endAction(i)
				
				if NUMBER[i] == 0 :
					Dead_index.append(i)
					apply_death = true
			
			if apply_death == true: # DEAD CHARACTER
				if Dead_index.size() == 1:
					
					TIMER.start(0.5)
					yield(TIMER, "timeout")
					CHARACTERS[Dead_index[0]].queue_free() # Suppression effective
					Character_number -=1
					CHARACTERS.remove(Dead_index[0])
					STATS.remove(Dead_index[0])
					TEMPORARY.remove(Dead_index[0])
					
					Priorities.remove(Dead_index[0])
					
					NAME.remove(Dead_index[0])
					SIDE.remove(Dead_index[0])
					FACTION.remove(Dead_index[0])
					RANGED.remove(Dead_index[0])
					ARROW.remove(Dead_index[0])
					NUMBER.remove(Dead_index[0])
					DAMAGE.remove(Dead_index[0])
					DISPLACEMENT.remove(Dead_index[0])
					INITIATIVE.remove(Dead_index[0])
					MAX_HP.remove(Dead_index[0])
					TOTAL_HP.remove(Dead_index[0])
					
					MOUSE.get_node("Mouse_Front").Character_number -=1
				elif Dead_index.size() > 1:
					for i in range(Dead_index.size(), 0): # Compte à rebours pour éviter les décalages
						if apply_death == true: # DEAD CHARACTER
							Character_number -=1
							CHARACTERS.remove(Dead_index[i])
							STATS.remove(Dead_index[i])
							TEMPORARY.remove(Dead_index[i])
							
							Priorities.remove(Dead_index[i])
							
							NAME.remove(Dead_index[i])
							SIDE.remove(Dead_index[i])
							FACTION.remove(Dead_index[i])
							RANGED.remove(Dead_index[i])
							ARROW.remove(Dead_index[i])
							NUMBER.remove(Dead_index[i])
							DAMAGE.remove(Dead_index[i])
							DISPLACEMENT.remove(Dead_index[i])
							INITIATIVE.remove(Dead_index[i])
							MAX_HP.remove(Dead_index[i])
							TOTAL_HP.remove(Dead_index[i])
							Active_turn.remove(Dead_index[i])
							
							MOUSE.get_node("Mouse_Front").Character_number -=1
							
							TIMER.start(0.2)
							yield(TIMER, "timeout")
							CHARACTERS[Dead_index[i]].queue_free() # Suppression effective
				apply_death = false
			
			yield(get_tree(), "idle_frame")
			print(Priorities)
			PrepareNextTurn(ActiveCharacter_index)
		else:
			activatePlayer()
		
		Control_oneTurn = false
	
	retrieveNodes()
	if FightVictory == false:
		for i in Character_number:
			if Active_turn[i] == true:
				print(STATS[i].NAME, " is going to play")
#				if STATS[i].IA == true:
#					MOUSE.emit_signal("mouse_clic", MOUSE.Action_Position, MOUSE.Tile_position)
	
	MOUSE.Mouse_Inhibition = false
#==============================================================

func retrieveNodes():
	MOUSE = get_node("/root/MainNode/Battlefield/Mouse_Cursor")
	FrontMOUSE  = get_node("/root/MainNode/Battlefield/Mouse_Cursor/Mouse_Front")
	TWEEN = get_parent().get_node("Tween")
	MAIN = get_node("/root/MainNode")
	TIMER = get_node("/root/MainNode/Battlefield/Timer")
	MACARON = get_parent().get_node("UI/BottomMenu/Macaron")
	
	CHARACTERS = []
	CHARACTERS = get_children()
	Character_number = get_child_count()
	
	TEMPORARY = []
	STATS = 	[]
	for i in Character_number:
		TEMPORARY.append(0)
		TEMPORARY[i] = CHARACTERS[i].get_node("Temporary")
#		IA.append(0)
#		IA[i] = CHARACTERS[i].get_node("IA")
		STATS.append(0)
		STATS[i] = CHARACTERS[i].get_node("icon/Stats")

func retrieveStats():
	NAME  			= []
	SIDE 			= []
	FACTION 		= []
	RANGED 			= []
	ARROW  			= []
	DAMAGE  		= []
	DISPLACEMENT 	= []
	INITIATIVE	 	= []
	MAX_HP 			= []
	TOTAL_HP 		= []
	Priorities 		= []
	
	for i in Character_number:
		NAME.append(STATS[i].CODENAME)
		SIDE.append(STATS[i].SIDE)
		FACTION.append(STATS[i].FACTION)
		RANGED.append(STATS[i].RANGED)
		ARROW.append(STATS[i].ARROW)
		DAMAGE.append(STATS[i].DAMAGE)
		DISPLACEMENT.append(STATS[i].DISPLACEMENT)
		INITIATIVE.append(STATS[i].INITIATIVE)
		MAX_HP.append(STATS[i].MAX_HP)
		TOTAL_HP.append(MAX_HP[i]*NUMBER[i])
		COUNTERSTRIKE_READY.append(true)
		COUNTERSTRIKE_ALLOWED.append(true)
		# Update counters
		var Unit_Label = CHARACTERS[i].get_node("Unit_Counter/UnitCounterColor/ColorRect/Label")
		Unit_Label.text = str(NUMBER[i])
		
	Priorities = INITIATIVE.duplicate()

func activatePlayer():
	Highest_priority = 0
	if Character_number > 1:
		Active_turn = []
		for i in Character_number:
			Active_turn.append(false)
			get_child(i).active_turn = false
			if Priorities[i] > Highest_priority:
				Highest_priority = Priorities[i] 
				ActiveCharacter_index = i
	else:
		ActiveCharacter_index = 0
	
	Active_turn[ActiveCharacter_index] = true
	COUNTERSTRIKE_READY[ActiveCharacter_index] = true
	get_child(ActiveCharacter_index).active_turn = true
	drawDisplacementTiles(ActiveCharacter_index)
	FrontMOUSE.Current_Side = STATS[ActiveCharacter_index].SIDE
	
	# Update Macaron
	var MACARON_RANGE : Node = get_parent().get_node("UI/BottomMenu/Macaron/MacaronFond_Distance/Macaron_Distance")
	if RANGED[ActiveCharacter_index] ==true:
		MACARON_RANGE.modulate = Color(1,1,1,1)
	else:
		MACARON_RANGE.modulate = Color(0.4,0.4,0.4,1)
	
	updateTurnChronology()

func updateTurnChronology():
	var CHRONOLOGY = get_node("/root/MainNode/Battlefield/UI/BottomMenu/Chronology")
	var savePriorities = Priorities.duplicate()
	CHRONOLOGY.updateChronology(savePriorities)

func PrepareNextTurn(Char_index):
	underTurn = (underTurn+ 1) % Character_number
	if underTurn == 1:
		Count_Turn_number += 1
		var TurnLabel = get_parent().get_node("UI/BottomMenu/Label_Turn")
		TurnLabel.text = str(" Turn ", Count_Turn_number)
	print(" ")
	print("--- Turn ", Count_Turn_number, " (Unit ", underTurn, "/", Character_number,") ---")
	
	retrieveNodes()
	activatePlayer()
	Victory(Char_index)

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# === PLAYING CHARACTER ===
func _PlayAction(Character, Mouse_tile, Mouse_Action):
	
#	if STATS.IA == true: # si IA (pas de Target_tile)
#		displacement_allowed = true
		
	var CharacterPosition = Character.global_position
	
	if(abs(Mouse_tile.x - CharacterPosition.x) <= 32 
	&& abs(Mouse_tile.y - CharacterPosition.y) <= 32): 	# Cas où l'unité attaque ou CaC
		ActiveCharacterPlayed = true					# Si deplacement+attaque géré dans TURN_MainFunction
		Character.ANIM_MeleeAttack(Mouse_Action)
		yield(TWEEN, "tween_completed")
		
	elif (Character.displacement_allowed == true): 			# Cas où l'unité se déplace.
#		if STATS.IA == true: # si IA (pas de Target_tile)
#			var IA_Tile_position
#			Mouse_tile = IA_Tile_position
		CharacterIsMoving = true
		ANIM_displacement(TargetTile_Position, Character)
		ActiveCharacterPlayed = true
		
	elif Character.get_node("icon/Stats").RANGED == true : # Cas d'attaque à distance
		var warning_count : int = 0
		for i in Character_number:
			if (abs(Mouse_Action.x-CHARACTERS[i].global_position.x) < 32
			 && abs(Mouse_Action.y-CHARACTERS[i].global_position.y) < 32):
				ActiveCharacterPlayed = true
				Character.ANIM_rangedAttack(Mouse_Action)
				COUNTERSTRIKE_ALLOWED[i] = false
				yield(TWEEN, "tween_completed")
				break
			elif warning_count == 0 :
				print("clicked outside (ranged)")
				warning_count +=1
	else:
		print("clicked outside")

func allowing_movement(Target_tile_position): # triggered by target tile
	# displacement_allowed = true
	TargetTile_Position = Target_tile_position

func ANIM_displacement(displacement_Tile, Character_Node):
	Character_Node.get_node("icon").onAction(displacement_Tile, Character_Node.global_position)
	TWEEN.interpolate_property(Character_Node, 
								"position", 
								Character_Node.global_position, 
								displacement_Tile, 
								0.5, 
								Tween.TRANS_LINEAR, 
								Tween.EASE_OUT)
	TWEEN.start()
	yield(TWEEN, "tween_completed")

func endAction(Char_index):
		Priorities[Char_index] = 0.0
		Active_turn[Char_index] = false
		if CHARACTERS[Char_index].has_node("Active_Border"):
			CHARACTERS[Char_index].get_node("Active_Border").queue_free()
#=======================================

func drawDisplacementTiles(Char_index):
	var new_tile
	var tile_size : int = 64
	
	var Characters_positions = []
	
	var TilesColor = TEMPORARY[Char_index].TilesColor
	
	# Active border
	var Active_Border = load(Active_Border_path)
	var add_child = Active_Border.instance()
	CHARACTERS[Char_index].add_child(add_child, true)
	add_child.z_as_relative = false
	add_child.z_index = get_child(Char_index).z_index+1
	
	# Displacement tiles
	for i in Character_number:
		Characters_positions.append(0)
		Characters_positions[i] = get_child(i).global_position
	
	if DISPLACEMENT[Char_index] != 0:
		var Disp_Tiles = load(Disp_Tiles_path)
		var OBSTACLES = get_node("/root/MainNode/Battlefield/Obstacles")
		for n in range(-DISPLACEMENT[Char_index], DISPLACEMENT[Char_index]+1):
			for m in range(-DISPLACEMENT[Char_index], DISPLACEMENT[Char_index]+1):
				new_tile = Disp_Tiles.instance()
				TEMPORARY[Char_index].add_child(new_tile, true)
				
				new_tile.modulate = Color(TilesColor[0], TilesColor[1], TilesColor[2], .9)
				new_tile.ModulateColor = Color(TilesColor[0], TilesColor[1], TilesColor[2], .9)
				new_tile.position = Vector2(n*tile_size, 
											m*tile_size)
				
				# Supprime les angles
				if n==0 && m==0:
					new_tile.queue_free()
				if n==DISPLACEMENT[Char_index] && m==-DISPLACEMENT[Char_index]:
					new_tile.queue_free()
				if n==DISPLACEMENT[Char_index] && m==DISPLACEMENT[Char_index]:
					new_tile.queue_free()
				if n==-DISPLACEMENT[Char_index] && m==-DISPLACEMENT[Char_index]:
					new_tile.queue_free()
				if n==-DISPLACEMENT[Char_index] && m==DISPLACEMENT[Char_index]:
					new_tile.queue_free()
				
				# Supprime si hors du terrain
				if (new_tile.global_position.x < X_lowerLimit 
				|| new_tile.global_position.x > X_upperLimit
				|| new_tile.global_position.y < Y_lowerLimit 
				|| new_tile.global_position.y > Y_upperLimit):
					new_tile.queue_free()
				
				# Supprime si un autre personnage est présent sur la case
				for i in Character_number:
					if abs(TEMPORARY[Char_index].global_position.x + tile_size*n - Characters_positions[i].x) <16:
						if abs(TEMPORARY[Char_index].global_position.y + tile_size*m - Characters_positions[i].y) <16:
							new_tile.queue_free()
				
				# Supprime si un obstacle est présent sur la case
				for i in OBSTACLES.get_child_count():
					var Obstacle_position = OBSTACLES.get_child(i).global_position
					if abs(TEMPORARY[Char_index].global_position.x + tile_size*n - Obstacle_position.x) <16:
						if abs(TEMPORARY[Char_index].global_position.y + tile_size*m - Obstacle_position.y) <16:
							new_tile.queue_free()
	else:
		print("DISPLACEMENT = 0")
	
	# Marqueur d'attaque à distance
	if STATS[Char_index].RANGED == true :
		var Ranged_Tile = load(Ranged_Tile_path)
		MACARON.Ranged_playing = true
		for i in Character_number:
			if SIDE[i] != SIDE[Char_index]:
				new_tile = Ranged_Tile.instance()
				CHARACTERS[i].add_child(new_tile, true)
				new_tile.modulate = Color(1, 0, 0, .9)
				

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# === NOT PLAYING CHARACTERS ===
func _PassiveAction(Mouse_action, Mouse_Tile, Char_index):
	Character_attacked(Mouse_action, Mouse_Tile, Char_index)
	Priorities[Char_index] += float(INITIATIVE[Char_index]) / float(Character_number)

# warning-ignore:unused_argument
func Character_attacked(Attacked_Action_position, Mouse_Tile, Char_index):
	var Damage_taken : int = 0
	var ATTACKER
	var DEFENDER
	if Attacked_Action_position != null:
		if (abs(Attacked_Action_position.x - CHARACTERS[Char_index].global_position.x) <= 32
		&& abs(Attacked_Action_position.y - CHARACTERS[Char_index].global_position.y) <= 32):
			DEFENDER = Char_index
			
			for i in get_child_count():
				if Active_turn[i] == true:
					ATTACKER = i
					
			if SIDE[ATTACKER] != SIDE[DEFENDER] :
				print(NAME[DEFENDER], " is attacked by ", NAME[ATTACKER])
				Damage_taken = DAMAGE[ATTACKER] * NUMBER[ATTACKER]
				
				# Attack damage application
				TOTAL_HP[DEFENDER] = int(max(0,TOTAL_HP[DEFENDER] - Damage_taken))
				var Def_number_before_attack : int = NUMBER[DEFENDER]
				NUMBER[DEFENDER] = int(ceil(float(float(TOTAL_HP[DEFENDER])/float(MAX_HP[DEFENDER]))))
				var Dead_number = Def_number_before_attack - NUMBER[DEFENDER]
				if Dead_number > 0:
					get_parent().updateHuntingBoards(CHARACTERS[ATTACKER], SIDE[ATTACKER], 
														NAME[DEFENDER], Dead_number)
				
				CHARACTERS[DEFENDER].get_node("Unit_Counter/UnitCounterColor/ColorRect/Label").text = String(NUMBER[DEFENDER])
				
				var PopupDamages = load(DamagePopup_path)
				PopupDamages = PopupDamages.instance()
				CHARACTERS[DEFENDER].add_child(PopupDamages, true)
				PopupDamages.rect_position = Vector2(-32, -36)
				PopupDamages.text = str("-", Damage_taken)
				
				if NUMBER[DEFENDER] > 0:
					print(NUMBER[DEFENDER], " members left in ", NAME[DEFENDER], " unit")
					
					# CounterStrike
					if (COUNTERSTRIKE_READY[Char_index] == true 
					&& COUNTERSTRIKE_ALLOWED[Char_index] == true):
						get_child(Char_index).ANIM_CounterStrike(CHARACTERS[ATTACKER].global_position)
						var CounterStrikeDmg = ceil(0.5*DAMAGE[DEFENDER]*NUMBER[DEFENDER])
						TOTAL_HP[ATTACKER] = int(max(0,TOTAL_HP[ATTACKER] - CounterStrikeDmg))
						var Atk_number_before_attack : int = NUMBER[ATTACKER]
						NUMBER[ATTACKER] = int(ceil(float(float(TOTAL_HP[ATTACKER])/float(MAX_HP[ATTACKER]))))
						Dead_number = Atk_number_before_attack - NUMBER[ATTACKER]
						if Dead_number > 0:
							get_parent().updateHuntingBoards(CHARACTERS[DEFENDER], SIDE[DEFENDER], 
																NAME[ATTACKER], Dead_number)
						
						CHARACTERS[ATTACKER].get_node("Unit_Counter/UnitCounterColor/ColorRect/Label").text = String(NUMBER[ATTACKER])
						print(NAME[DEFENDER], " counter-strikes : ", CounterStrikeDmg, " damages")
						COUNTERSTRIKE_READY[DEFENDER] = false
					else:
						COUNTERSTRIKE_ALLOWED[Char_index] = true
				
				elif NUMBER[DEFENDER] <1: # DEAD CHARACTER (ne s'applique que dans TURN_Main)
					print(NAME[DEFENDER], " is dead")
				else:
					print(NUMBER[DEFENDER], " ", NAME[DEFENDER], " left")
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Victory Conditions ~~~~~~~~~~~~~
# warning-ignore:unused_argument
func Victory(Char_index):
	StandardVictory()
	
#	if FACTION[Char_index] == 'Graveyard':
#		GraveyardVictory(Char_index)
	pass

func StandardVictory(): #Si un camp n'a plus d'unite, l'autre gagne.
	var MAIN_Node : Node = get_parent().get_parent()
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
		
		get_parent().remainingSquad = [CHARACTERS, NUMBER]
		MAIN_Node.load_Victory_Screen(Winner)

#Si un necromancien ressucite l'equivalent de 25% de l'armee adverse, il gagne.
#func GraveyardVictory(Char_index):
#	var Winner : int
#	var Opposite_Army_value : int
#
#	#Mettre à jour l'affichage du score de resurrection
#
#	if float(Resurection_score) > 0.25 * float(Opposite_Army_value):
#		Winner = SIDE[Char_index]
#		MAIN.load_Victory_Screen(Winner)
#	pass
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

func NothingTWEEN(a,b):
	pass
	print("Tween completed ", a, " ", b)
func NothingTIMER():
	pass
	print("Timer completed")