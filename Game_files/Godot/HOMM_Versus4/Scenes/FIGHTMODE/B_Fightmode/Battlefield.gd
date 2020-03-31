extends Node2D

var Battlefield : String

var Faction1 : String
var Heroes1 : String
var Color1 : Color
var AI1 : bool
var Army1 : Array # Format : [[Unit names], [Unit number]]
var HuntingBoard1 : Array = [[], [], [], []] 
# Format : [ [Hunter IDs] [Hunter names] [[Prey names]], [[Prey number]] ]


var Faction2 : String
var Heroes2 : String
var Color2 : Color
var AI2 : bool
var Army2 : Array # Format : [[Unit names], [Unit number]]
var HuntingBoard2 : Array = [[], [], [], []]  
# Format : [ [Hunter IDs] [Hunter names] [[Prey names]], [[Prey number]] ]

# warning-ignore:unused_class_variable
var remainingSquad = [[], []]

func drawBattlefield(): # Draw background and obstacles
	get_node("Background").Draw_Background(Battlefield)
	get_node("Obstacles").Draw_ALLObstacles(Battlefield, 2)

func setArmies(): # set Units and Heroes
	setUnitsOnBattlefield(Army1, Heroes1, Faction1, 1, Color1, AI1)
	setUnitsOnBattlefield(Army2, Heroes2, Faction2, 2, Color2, AI2)

func init_HuntingBoard():
	# Initialisation des tableaux de chasse
	var TURN = get_node("Turn")
	for i in TURN.get_child_count():
		if TURN.get_child(i).STATS.SIDE == 1:
			HuntingBoard1[0].append(TURN.CHARACTERS[i])
			HuntingBoard1[1].append(TURN.get_child(i).STATS.NAME)
			HuntingBoard1[2].append([])
			HuntingBoard1[3].append([])
		elif TURN.get_child(i).STATS.SIDE == 2:
			HuntingBoard2[0].append(TURN.CHARACTERS[i])
			HuntingBoard2[1].append(TURN.get_child(i).STATS.NAME)
			HuntingBoard2[2].append([])
			HuntingBoard2[3].append([])

func setUnitsOnBattlefield(Army, Heroes, Faction, Side, playerColor, AI):
	var BATTLEFIELD = get_node("UI/Battlefield_Limits")
	
	var X_lowerLimit = BATTLEFIELD.rect_global_position.x
	var X_upperLimit = BATTLEFIELD.rect_global_position.x + BATTLEFIELD.rect_size.x
	var Y_lowerLimit = BATTLEFIELD.rect_global_position.y
	
	var TURN = get_node("Turn")
	var Unit_number = Army[0].size()
	var Units = Army[0]
	
	# Unit counter
	for i in Army[1].size():
		if Army[1][i] < 1:
			Units.remove(i)
			Unit_number = Units.size()
		else:
			TURN.NUMBER.append(Army[1][i])
	
	for i in Unit_number:
		var unit_path = str("res://Assets/TSCN/Units/", Units[i], "/", Units[i], ".tscn")
		var new_unit = load(unit_path)
		var CHARACTER = new_unit.instance()
		TURN.add_child(CHARACTER, true)
		
		var STATS = CHARACTER.get_node("icon/Stats")
		var TEMPORARY = CHARACTER.get_node("Temporary")
		var GRADIENT_BG = CHARACTER.get_node("icon/BG_Gradient")
		print(STATS.NAME) # controle du character
		
		STATS.SIDE = Side
		STATS.IA = AI
		STATS.NUMBER = Army[1][i]
		
		TEMPORARY.TilesColor = playerColor
		GRADIENT_BG.modulate = playerColor
		
		if Side == 1:
			CHARACTER.global_position.x = X_lowerLimit+64
			CHARACTER.global_position.y = 128*i+Y_lowerLimit+32
		elif Side == 2:
			CHARACTER.global_position.x = X_upperLimit-64
			CHARACTER.global_position.y = 128*i+Y_lowerLimit+32
		else: # Par défaut, on aligne les unités en haut de l'écran.
			CHARACTER.global_position.x = 256+64*i
			CHARACTER.global_position.y = 0
	
	# Placement du héros
	var HEROES = load(str("res://Assets/TSCN/Heroes/", Heroes, "/", Heroes, ".tscn")) 
	var FACTION = load(str("res://Assets/TSCN/Factions/Icon_", Faction, ".tscn")) 
	if Side == 1:
		var heroes = HEROES.instance()
		get_node("UI/Border_Heroes_L").add_child(heroes, true)
		heroes.global_position.y -= 12
		heroes.z_index = 5
		heroes.z_as_relative = false
		heroes.scale = Vector2(1.5, 1.5)/0.75
		get_node("UI/Border_Heroes_L/Fond").modulate = Color(playerColor[0], 
															playerColor[1], 
															playerColor[2], 
															1)
		
		var faction = FACTION.instance()
		heroes.add_child(faction, true)
		faction.scale = Vector2(0.1,0.1)
		faction.z_index += 5
		faction.position.x -= 50
		
	elif Side == 2:
		var heroes = HEROES.instance()
		get_node("UI/Border_Heroes_R").add_child(heroes, true)
		heroes.global_position.y -= 12
		heroes.z_index = 5
		heroes.z_as_relative = false
		heroes.scale = Vector2(-1.5, 1.5)/0.75
		get_node("UI/Border_Heroes_R/Fond").modulate = Color(playerColor[0], 
															playerColor[1], 
															playerColor[2], 
															1)
		
		var faction = FACTION.instance()
		heroes.add_child(faction, true)
		faction.scale = Vector2(0.1,0.1)
		faction.z_index += 5
		faction.position.x -= 51

func updateHuntingBoards(Hunter_ID, Hunter_Side, Prey_name, Prey_number):
	if Hunter_Side == 1:
		updateHuntingBoard(HuntingBoard1, Hunter_ID, Prey_name, Prey_number)
	elif Hunter_Side == 2:
		updateHuntingBoard(HuntingBoard2, Hunter_ID, Prey_name, Prey_number)
	else:
		print("There is a problem updating Hunting boards")

func updateHuntingBoard(Board, Hunter_ID, Prey_name, Prey_number):
	var alreadykilled : bool = false
	var alreadykilled_index : int
	if Prey_number > 0:
		for i in Board[0].size():
			if Hunter_ID == Board[0][i]:
				if Board[2][i].size() > 0:
					for j in Board[2][i].size():
						if Board[2][i][j] == Prey_name:
							alreadykilled = true
							alreadykilled_index = j
							break
						else:
							alreadykilled = false
					
					if alreadykilled == false:
						Board[2][i].append(Prey_name)
						Board[3][i].append(Prey_number)
						break
					else:
						Board[3][i][alreadykilled_index] += Prey_number
						break
				else:
					Board[2][i].append(Prey_name)
					Board[3][i].append(Prey_number)
					break