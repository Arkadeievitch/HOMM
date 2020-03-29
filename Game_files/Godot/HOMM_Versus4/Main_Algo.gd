extends Node
var Battlefield_path : String = "res://Scenes/FIGHTMODE/B_Fightmode/Battlefield.tscn"
var VictoryScreen_path : String = "res://Scenes/FIGHTMODE/C_Victory/VictoryScreen.tscn"
var SelectionMenu_path : String = "res://Scenes/FIGHTMODE/A_SelectionMenu/Selection_Menu.tscn"
var FightInformations = [] #Stockage en début de combat pour l'écran de victoire

func _ready():
	load_Selection_Menu()

func changeSelectiontoFightmode():
	var InfosFromSelection = saveInfoFromSelection()
	var ARMY1_INFOS = InfosFromSelection[0]
	var ARMY2_INFOS = InfosFromSelection[1]
	var Heroes1 = InfosFromSelection[2]
	var Heroes2 = InfosFromSelection[3]
	var Battlefield = InfosFromSelection[4]
	var Faction1 = InfosFromSelection[5]
	var Faction2 = InfosFromSelection[6]
	
	FightInformations = [ARMY1_INFOS, ARMY2_INFOS, Heroes1, Heroes2,  Faction1, Faction2]
	load_Fightmode(Battlefield, ARMY1_INFOS, ARMY2_INFOS, Heroes1, Heroes2, Faction1, Faction2)

func saveInfoFromSelection():
	var SELECTIONMENU = get_node("/root/MainNode/SelectionMenu")
	var BATTLEFIELD = SELECTIONMENU.ChosenBattlefield
	
	var TABLE1 = SELECTIONMENU.get_node("Table_Player1")
	var TABLE2 = SELECTIONMENU.get_node("Table_Player2")
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
	
	var FACTION1 : String = ARMY1.get_child(0).name.right(5)
	var FACTION2 : String = ARMY2.get_child(0).name.right(5)
	
	return [ARMY1_infos, ARMY2_infos, HEROES1, HEROES2, BATTLEFIELD, FACTION1, FACTION2]

func load_Selection_Menu(): # appel bouton
	if get_child_count() > 0:
		changeScene(SelectionMenu_path)
	else:
		var SelectionMenuNode = load(SelectionMenu_path).instance()
		add_child(SelectionMenuNode, true)
	
	yield(get_tree(), "idle_frame")
	if get_child_count() > 0:
		var BUTTON_ENGAGE = get_node("SelectionMenu/Button_Engage/Button_Engage")
		BUTTON_ENGAGE.connect("Engaged_pressed", self, "changeSelectiontoFightmode")

func load_Fightmode(Battlefield, Army1, Army2, Heroes1, Heroes2, Faction1, Faction2):
	
	changeScene(Battlefield_path)
	
	get_node("Battlefield").Battlefield = Battlefield
	get_node("Battlefield").Heroes1 = Heroes1
	get_node("Battlefield").Heroes2 = Heroes2
	get_node("Battlefield").Army1 = Army1
	get_node("Battlefield").Army2 = Army2
	get_node("Battlefield").Faction1 = Faction1
	get_node("Battlefield").Faction2 = Faction2
	
	get_node("Battlefield").drawBattlefield() # Draw background and obstacles
	get_node("Battlefield").setArmies() # Set Units and Heroes on Battlefield

func load_Victory_Screen(Winner): # appel depuis Fightmode
	if get_child_count() > 0:
		changeScene(VictoryScreen_path)
	else:
		add_child(load(VictoryScreen_path).instance(), true)
	
	get_node("VictoryScreen").VictoryScreen(FightInformations, Winner)
	
	var Button_ReturnMenu = get_node("VictoryScreen/Button_ReturnMenu")
	Button_ReturnMenu.connect("button_up", self, "load_Selection_Menu")

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