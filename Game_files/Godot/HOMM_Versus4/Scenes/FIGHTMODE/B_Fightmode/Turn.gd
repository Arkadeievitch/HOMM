extends Node

var DamagePopup_path = "res://Scenes/FIGHTMODE/B_Fightmode/Resources/DamagePopup/DamagePopup.tscn"
var Disp_Tiles = load("res://Scenes/FIGHTMODE/B_Fightmode/Resources/Temporary_Tiles/Ground_Tiles.tscn")
var Active_Border = load("res://Scenes/FIGHTMODE/B_Fightmode/Resources/Active_Border/Active_Border.tscn")

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

# Battlefield limits
var X_lowerLimit : int
var X_upperLimit : int
var Y_lowerLimit : int
var Y_upperLimit : int

# ---- STATS ----
var NAME  		= []

var SIDE 		= []
var FACTION 	= []
var RANGED 		= []
var ARROW  		= []
var NUMBER  	= []
var DAMAGE  	= []

var DISPLACEMENT = []
var INITIATIVE	 = []

var MAX_HP 		= []
var TOTAL_HP 	= []
# ---- STATS ----

var displacement_allowed : bool = false

var MouseActionTarget : Vector2

func _ready():
	if has_node("/root/MainNode/SelectionMenu"):
		# warning-ignore:return_value_discarded
		get_node("/root/MainNode/SelectionMenu").connect("tree_exited", self, "initialize")

func initialize(): # Attend la fermeture du menu pour démarrer
	print("--- Turn ", Count_Turn_number, " (", underTurn, ") ---")
	retrieveNodes()
	connectSelf()
	retrieveStats()
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
											# (notamment pour les tweens de projectiles)
	
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

func retrieveStats():
	NAME  		= []
	SIDE 		= []
	FACTION 	= []
	RANGED 		= []
	ARROW  		= []
	NUMBER  	= []
	DAMAGE  	= []
	DISPLACEMENT = []
	INITIATIVE	 = []
	MAX_HP 		= []
	TOTAL_HP 	= []
	Priorities = []
	
	for i in Character_number:
		Priorities.append(0)
		Priorities[i] = get_child(i).Priority
		NAME.append(0)
		NAME[i]  = STATS[i].NAME
		SIDE.append(0)
		SIDE  = STATS[i].SIDE
		FACTION.append(0)
		FACTION  = STATS[i].FACTION
		RANGED.append(0)
		RANGED  = STATS[i].RANGED
		ARROW.append(0)
		ARROW  = STATS[i].ARROW
		NUMBER.append(0)
		NUMBER  = STATS[i].NUMBER
		DAMAGE.append(0)
		DAMAGE  = STATS[i].DAMAGE
		DISPLACEMENT.append(0)
		DISPLACEMENT  = STATS[i].DISPLACEMENT
		INITIATIVE.append(0)
		INITIATIVE  = STATS[i].INITIATIVE
		MAX_HP.append(0)
		MAX_HP  = STATS[i].MAX_HP
		TOTAL_HP.append(0)
		TOTAL_HP  = STATS[i].TOTAL_HP

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
	retrieveStats() # Bizarrerie : la fonction update Chronology édite la valeur de Priorities
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
	retrieveStats()
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

func _PassiveAction(Mouse_action):
	Character_attacked(Mouse_action)
	incrementPriorities()

func incrementPriorities():
	Priorities += float(STATS.INITIATIVE) / float(get_parent().Character_number)

# warning-ignore:unused_argument
func Character_attacked(Attacked_Action_position):
	var Damage_taken : int = 0
	var ATTACKER
	if Attacked_Action_position != null:
		if (abs(Attacked_Action_position.x - self.global_position.x) <= 32
		&& abs(Attacked_Action_position.y - self.global_position.y) <= 32):
			
			for i in get_child_count():
				if get_child(i).active_turn == true:
					ATTACKER = get_child(i).get_node("icon/Stats")
					
			if ATTACKER.SIDE != STATS.SIDE :
				print(STATS.NAME, " is attacked by ", ATTACKER.NAME)
				Damage_taken = ATTACKER.DAMAGE * ATTACKER.NUMBER
				
				STATS.TakeDamage(Damage_taken)
				STATS.UpdateNumberFromHP()
				
				var PopupDamages = load(DamagePopup_path)
				PopupDamages = PopupDamages.instance()
				add_child(PopupDamages, true)
				PopupDamages.rect_position = Vector2(-32, -36)
				PopupDamages.text = str("-", Damage_taken)
				
				if STATS.NUMBER > 1:
					print(STATS.NUMBER, " members left in ", STATS.NAME, " unit")
				else:
					print(STATS.NUMBER, " ", STATS.NAME, " left")

func UpdateNumberFromHP():
	NUMBER = int(ceil(float(float(TOTAL_HP)/float(MAX_HP))))

func TakeDamage(Damage_taken):
	TOTAL_HP = int(max(0,TOTAL_HP - Damage_taken))

#=========================================
# warning-ignore:unused_argument
func _PlayAction(Mouse_tile, Mouse_Action):
	
	if STATS.IA == true: # si IA (pas de Target_tile)
		displacement_allowed = true
		
	var SelfPosition = self.global_position
	if(abs(Mouse_tile.x - SelfPosition.x) <= 32 
	&& abs(Mouse_tile.y - SelfPosition.y) <= 32): 	# Cas où l'unité attaque ou CaC
		get_parent().ActiveCharacterPlayed = true
		CHARACTERS.ANIM_MeleeAttack()
	elif (displacement_allowed == true): 			# Cas où l'unité se déplace.
		if STATS.IA == true: # si IA (pas de Target_tile)
			var IA_Tile_position
			Mouse_tile = IA_Tile_position
		get_parent().CharacterIsMoving = true
		CHARACTERS.ANIM_displacement(Mouse_tile)
		get_node("icon").onAction(Mouse_Action, Mouse_tile)
		if not(Mouse_Action.x == Mouse_tile.x && Mouse_Action.y == Mouse_tile.y):
			CHARACTERS.ANIM_MeleeAttack()
		get_parent().ActiveCharacterPlayed = true
	elif STATS.RANGED == true : # Cas d'attaque à distance
		get_parent().ActiveCharacterPlayed = true
		CHARACTERS.ANIM_rangedAttack(Mouse_Action)
	else:
		print("clicked outside")
#=========================================

func endAction():
		Priorities = 0.0
		if has_node("Active_Border"):
			get_node("Active_Border").queue_free()

func drawDisplacementTiles(Char_index):
	var new_tile
	var tile_size : int = 64
	
	var Characters_positions = []
	
	var TilesColor = TEMPORARY[Char_index].TilesColor
	
	if get_parent().active_turn == true:
		# Active border
		var add_child = Active_Border.instance()
		get_parent().add_child(add_child, true)
		add_child.z_as_relative = false
		add_child.z_index = get_parent().z_index+1
		
		# Displacement tiles
		for i in Character_number:
			Characters_positions.append(0)
			Characters_positions[i] = get_child(i).position
		
		if STATS.DISPLACEMENT != 0:
			var OBSTACLES = get_node("/root/MainNode/Battlefield/Obstacles")
			for n in range(-STATS.DISPLACEMENT, STATS.DISPLACEMENT+1):
				for m in range(-STATS.DISPLACEMENT, STATS.DISPLACEMENT+1):
					new_tile = Disp_Tiles.instance()
					add_child(new_tile, true)
					
					new_tile.modulate = Color(TilesColor[0], TilesColor[1], TilesColor[2], .9)
					new_tile.position = Vector2(n*tile_size, 
												m*tile_size)
					
					# Supprime les angles
					if n==0 && m==0:
						new_tile.queue_free()
					if n==STATS.DISPLACEMENT && m==-STATS.DISPLACEMENT:
						new_tile.queue_free()
					if n==STATS.DISPLACEMENT && m==STATS.DISPLACEMENT:
						new_tile.queue_free()
					if n==-STATS.DISPLACEMENT && m==-STATS.DISPLACEMENT:
						new_tile.queue_free()
					if n==-STATS.DISPLACEMENT && m==STATS.DISPLACEMENT:
						new_tile.queue_free()
					
					# Supprime si hors du terrain
					if (new_tile.global_position.x < X_lowerLimit 
					|| new_tile.global_position.x > X_upperLimit
					|| new_tile.global_position.y < Y_lowerLimit 
					|| new_tile.global_position.y > Y_upperLimit):
						new_tile.queue_free()
					
					# Supprime si un autre personnage est présent sur la case
					for i in Character_number:
						if abs(self.global_position.x + tile_size*n - Characters_positions[i].x) <16:
							if abs(self.global_position.y + tile_size*m - Characters_positions[i].y) <16:
								new_tile.queue_free()
					
					# Supprime si un obstacle est présent sur la case
					for i in OBSTACLES.get_child_count():
						var Obstacle_position = OBSTACLES.get_child(i).global_position
						if abs(self.global_position.x + tile_size*n - Obstacle_position.x) <16:
							if abs(self.global_position.y + tile_size*m - Obstacle_position.y) <16:
								new_tile.queue_free()
			
			emit_signal("Temporary_finished")
		else:
			print("DISPLACEMENT = 0")