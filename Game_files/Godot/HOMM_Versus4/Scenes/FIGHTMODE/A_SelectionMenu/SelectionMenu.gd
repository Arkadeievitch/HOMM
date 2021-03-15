extends Control

var BATTLEFIELD : String = "Plaine"

func Select_Battlefield(BattlefieldName):
	BATTLEFIELD = BattlefieldName

func saveInfoFromSelection():
	
	var TABLE1 = get_node("Table_Player1")
	var TABLE2 = get_node("Table_Player2")
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
