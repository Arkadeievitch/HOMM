extends Node

func _ready():
	load_Selection_Menu()
	yield(get_tree(), "idle_frame")
	if get_child_count() > 0:
		var BUTTON_ENGAGE = get_node("SelectionMenu/ButtonENGAGE")
		BUTTON_ENGAGE.connect("Engaged_pressed", self, "changeSelectiontoFightmode")

func changeSelectiontoFightmode():
	var InfosFromSelection = saveInfoFromSelection()
	var ARMY1_INFOS = InfosFromSelection[0]
	var ARMY2_INFOS = InfosFromSelection[1]
	var Heroes1 = InfosFromSelection[2]
	var Heroes2 = InfosFromSelection[3]
	
	load_Fightmode(ARMY1_INFOS, ARMY2_INFOS, Heroes1, Heroes2)

func saveInfoFromSelection():
	var SELECTIONMENU = get_node("/root/MainNode/SelectionMenu")
	var TABLE1 = SELECTIONMENU.get_child(0)
	var TABLE2 = SELECTIONMENU.get_child(1)
	var ARMY1 = TABLE1.get_node("Heroes/AllHeroesScene").get_child(0).get_node("defaultArmy")
	var ARMY2 = TABLE2.get_node("Heroes/AllHeroesScene").get_child(0).get_node("defaultArmy")
	var HEROES1 = TABLE1.get_node("Heroes/AllHeroesScene").get_child(0).name
	var HEROES2 = TABLE2.get_node("Heroes/AllHeroesScene").get_child(0).name
	
	var ARMY1_infos = [[], [], 0, 0, Color(1, 1, 1, 1)]
	var ARMY2_infos = [[], [], 0, 0, Color(1, 1, 1, 1)]
	
	if ARMY1.Unit_counters[0] > 0:
		ARMY1_infos[0] = ARMY1.Unit_names
		ARMY1_infos[1] = ARMY1.Unit_counters
		ARMY1_infos[2] = 1
		if TABLE1.get_node("Check_IA_Player").pressed == true:
			ARMY1_infos[3] = true
		else:
			ARMY1_infos[3] = false
		ARMY1_infos[4] = ARMY1.get_node("Label_Unit1/Unit_BG").ChosenColor
		
		
	if ARMY2.Unit_counters[0] > 0:
		ARMY2_infos[0] = ARMY2.Unit_names
		ARMY2_infos[1] = ARMY2.Unit_counters
		ARMY2_infos[2] = 2
		if TABLE2.get_node("Check_IA_Player").pressed == true:
			ARMY2_infos[3] = true
		else:
			ARMY2_infos[3] = false
		ARMY2_infos[4] = ARMY2.get_node("Label_Unit1/Unit_BG").ChosenColor
	
	return [ARMY1_infos, ARMY2_infos, HEROES1, HEROES2]

func load_Fightmode(Army1, Army2, Heroes1, Heroes2):
	changeScene("res://Scenes/Fightmode/Battlefield.tscn")
	
	setUnitsOnBattlefield(Army1, Heroes1)
	setUnitsOnBattlefield(Army2, Heroes2)

func setUnitsOnBattlefield(Army, Heroes):
	
	var TURN = get_node("Battlefield/Turn")
	var Unit_number = Army[0].size()
	var Units = Army[0]
	var Side
	
	for i in Army[1].size():
		if Army[1][i] < 1:
			Units.remove(i)
			Unit_number = Units.size()
	
	for i in Unit_number:
		var unit_path = str("res://Assets/Units/", Units[i], "/", Units[i], ".tscn")
		var new_unit = load(unit_path)
		var CHARACTER = new_unit.instance()
		TURN.add_child(CHARACTER, true)
		
		var STATS = CHARACTER.get_node("icon/Stats")
		var TEMPORARY = CHARACTER.get_node("Temporary")
		print(STATS.NAME) # controle du character
		
		Side = Army[2]
		STATS.SIDE = Side
		STATS.IA = Army[3]
		STATS.NUMBER = Army[1][i]
		
		TEMPORARY.TilesColor = Army[4]
		
		if Side == 1:
			CHARACTER.global_position.x = 224
			CHARACTER.global_position.y = 128*i+128+32
		elif Side == 2:
			CHARACTER.global_position.x = 928
			CHARACTER.global_position.y = 128*i+128+32
		else: # Par défaut, on aligne les unités en haut de l'écran.
			CHARACTER.global_position.x = 256+64*i
			CHARACTER.global_position.y = 0
	
	var HEROES = load(str("res://Assets/Heroes/", Heroes, "/", Heroes, ".tscn"))
	var heroes = HEROES.instance()
	get_node("Battlefield/UI").add_child(heroes, true)
	if Side == 1:
		heroes.global_position = Vector2(96,96)
		heroes.scale = Vector2(1.5, 1.5)
	elif Side == 2:
		heroes.global_position = Vector2(get_viewport().size.x-96,96)
		heroes.scale = Vector2(-1.5, 1.5)

#func load_Victory_Screen(Side, TileColor, Units, Unit_counters): # appel depuis Fightmode-Turn
func load_Victory_Screen(): # appel depuis Fightmode
	if get_child_count() > 0:
		changeScene("res://Scenes/Fightmode/VictoryScreen.tscn")
	else:
		add_child(load("res://Scenes/Fightmode/VictoryScreen.tscn").instance(), true)
		
	var Button_ReturnMenu = get_node("VictoryScreen/Button_ReturnMenu")
	Button_ReturnMenu.connect("button_up", self, "load_Selection_Menu")

func load_Selection_Menu():	# appel bouton
	if get_child_count() > 0:
		changeScene("res://Scenes/Fightmode/Selection_Menu.tscn")
	else:
		add_child(load("res://Scenes/Fightmode/Selection_Menu.tscn").instance(), true)

func changeScene(NextScenePath):
	get_child(0).queue_free()
	add_child(load(NextScenePath).instance(), true)

func saveArmyforExport(Army, internal_Unit_names, internal_Unit_counters, 
					internal_IA):
	for i in Army.get_child_count():
		internal_Unit_names.append(0)
		internal_Unit_names[i] = Army.get_child(i).text
		internal_Unit_counters.append(0)
		internal_Unit_counters[i] = int(Army.get_child(i).get_node("UnitCounter").text)
		
	return [internal_Unit_names, internal_Unit_counters, internal_IA]