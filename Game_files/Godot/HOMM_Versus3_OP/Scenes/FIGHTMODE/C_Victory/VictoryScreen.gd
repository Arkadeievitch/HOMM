extends Node2D

func VictoryScreen(FightInformations, Winner):
	
	var Heroes1 = FightInformations[2]
	var Heroes2 = FightInformations[3]
	
	var Unit_names1 = FightInformations[0][0]
	var Unit_names2 = FightInformations[1][0]
	var Unit_InitialCounters1 = FightInformations[0][1]
	var Unit_InitialCounters2 = FightInformations[1][1]
	var PlayerColor1 = FightInformations[0][4]
	var PlayerColor2 = FightInformations[1][4]
	
	get_node("Table_Player1/Army_synthese").loadSynthesis(Heroes1, 
											Unit_names1, Unit_InitialCounters1, 
											PlayerColor1)
	get_node("Table_Player2/Army_synthese").loadSynthesis(Heroes2, 
											Unit_names2, Unit_InitialCounters2, 
											PlayerColor2)
	
	if Winner == 1:
		get_node("Label_Victory").rect_global_position.x -= 320
	elif Winner == 2:
		get_node("Label_Victory").rect_global_position.x += 320