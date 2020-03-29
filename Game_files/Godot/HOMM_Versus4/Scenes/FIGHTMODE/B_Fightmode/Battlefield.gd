extends Node2D

var Battlefield : String

var Faction1 : String
var Heroes1 : String
var Army1 : Array

var Faction2 : String
var Heroes2 : String
var Army2 : Array

func drawBattlefield(): # Draw background and obstacles
	get_node("Background").Draw_Background(Battlefield)
	get_node("Obstacles").Draw_ALLObstacles(Battlefield, 2)

func setArmies(): # set Units and Heroes
	setUnitsOnBattlefield(Army1, Heroes1, Faction1)
	setUnitsOnBattlefield(Army2, Heroes2, Faction2)

func setUnitsOnBattlefield(Army, Heroes, Faction):
	
	var BATTLEFIELD = get_node("UI/Battlefield_Limits")
	
	var X_lowerLimit = BATTLEFIELD.rect_global_position.x
	var X_upperLimit = BATTLEFIELD.rect_global_position.x + BATTLEFIELD.rect_size.x
	var Y_lowerLimit = BATTLEFIELD.rect_global_position.y
	
	var TURN = get_node("Turn")
	var Unit_number = Army[0].size()
	var Units = Army[0]
	var Side
	
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
		
		Side = Army[2]
		STATS.SIDE = Side
		STATS.IA = Army[3]
		STATS.NUMBER = Army[1][i]
		
		TEMPORARY.TilesColor = Army[4]
		GRADIENT_BG.modulate = Army[4]
		
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
		get_node("UI/Border_Heroes_L/Fond").modulate = Color(Army[4][0], Army[4][1], Army[4][2], 1)
		
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
		
		get_node("UI/Border_Heroes_R/Fond").modulate = Color(Army[4][0], Army[4][1], Army[4][2], 1)
		var faction = FACTION.instance()
		heroes.add_child(faction, true)
		faction.scale = Vector2(0.1,0.1)
		faction.z_index += 5
		faction.position.x -= 51
