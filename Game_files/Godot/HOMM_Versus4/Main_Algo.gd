extends Node

var Battlefield_path : String = "res://Scenes/FIGHTMODE/B_Fightmode/Battlefield.tscn"
var VictoryScreen_path : String = "res://Scenes/FIGHTMODE/C_Victory/VictoryScreen.tscn"
var SelectionMenu_path : String = "res://Scenes/FIGHTMODE/A_SelectionMenu/Selection_Menu.tscn"
var FightInformations = [] #Stockage en début de combat pour l'écran de victoire
var remainingSquad = []

var ARMY1_INFOS # Contain [Names, numbers, Side, AI, color]
var ARMY2_INFOS # Contain [Names, numbers, Side, AI, color]
var Heroes1
var Heroes2
var Battlefield
var Faction1
var Faction2

# warning-ignore:unused_class_variable
var IDs_1 = []
# warning-ignore:unused_class_variable
var IDs_2 = []

func _ready():
	load_Selection_Menu()

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

func changeSelectiontoFightmode():
	var InfosFromSelection = get_node("SelectionMenu").saveInfoFromSelection()
	ARMY1_INFOS = 	InfosFromSelection[0] # Contain [Names, numbers, Side, AI, color]
	ARMY2_INFOS = 	InfosFromSelection[1] # Contain [Names, numbers, Side, AI, color]
	Heroes1 = 		InfosFromSelection[2]
	Heroes2 = 		InfosFromSelection[3]
	Battlefield = 	InfosFromSelection[4]
	Faction1 = 		InfosFromSelection[5]
	Faction2 = 		InfosFromSelection[6]
	
	load_Fightmode(ARMY1_INFOS, ARMY2_INFOS)

func updateFightInformation():
	FightInformations = [ARMY1_INFOS, ARMY2_INFOS, Heroes1, Heroes2,  Faction1, Faction2, IDs_1, IDs_2]

func load_Fightmode(ARMY1_infos, ARMY2_infos):
	
	changeScene(Battlefield_path)
	
	get_node("Battlefield").Battlefield = Battlefield
	get_node("Battlefield").Heroes1 = Heroes1
	get_node("Battlefield").Heroes2 = Heroes2
	get_node("Battlefield").Army1 = [ARMY1_infos[0], ARMY1_infos[1]]
	get_node("Battlefield").Army2 = [ARMY2_infos[0], ARMY2_infos[1]]
	get_node("Battlefield").Color1 = ARMY1_infos[4]
	get_node("Battlefield").Color2 = ARMY2_infos[4]
	get_node("Battlefield").AI1 = ARMY1_infos[3]
	get_node("Battlefield").AI2 = ARMY2_infos[3]
	get_node("Battlefield").Faction1 = Faction1
	get_node("Battlefield").Faction2 = Faction2
	
	get_node("Battlefield").drawBattlefield() # Draw background and obstacles
	get_node("Battlefield").setArmies() # Set Units and Heroes on Battlefield

func load_Victory_Screen(Winner): # appel depuis Fightmode
	var HuntingBoards = [[], []]
	if get_child_count() > 0:
		if has_node("Battlefield"):
			HuntingBoards = [get_node("Battlefield").HuntingBoard1, 
							 get_node("Battlefield").HuntingBoard2]
			remainingSquad = get_node("Battlefield").remainingSquad
		changeScene(VictoryScreen_path)
	else:
		add_child(load(VictoryScreen_path).instance(), true)
	
	get_node("VictoryScreen").VictoryScreen(FightInformations, Winner, HuntingBoards, remainingSquad)
	
	var Button_ReturnMenu = get_node("VictoryScreen/Button_ReturnMenu")
	Button_ReturnMenu.connect("button_up", self, "load_Selection_Menu")

func changeScene(NextScenePath):
	get_child(0).queue_free()
	add_child(load(NextScenePath).instance(), true)
