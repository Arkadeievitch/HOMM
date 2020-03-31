extends Node2D

var PlayerColor1
var PlayerColor2

# Format : [ [Hunter IDs] [Hunter names] [[Prey names]], [[Prey number]] ]
var HuntingBoard1 : Array = [[], [], [], []]
var HuntingBoard2 : Array = [[], [], [], []]

func VictoryScreen(FightInformations, Winner, HuntingBoards, remainingSquad):
	
	HuntingBoard1 = HuntingBoards[0].duplicate(true)
	HuntingBoard2 = HuntingBoards[1].duplicate(true)
	
	var Heroes1 = FightInformations[2]
	var Heroes2 = FightInformations[3]
	
	var Unit_names1 = FightInformations[0][0]
	var Unit_names2 = FightInformations[1][0]
	var Unit_InitialCounters1 = FightInformations[0][1]
	var Unit_InitialCounters2 = FightInformations[1][1]
	PlayerColor1 = FightInformations[0][4]
	PlayerColor2 = FightInformations[1][4]
	
	var Unit_IDs1 = FightInformations[6]
	var Unit_IDs2 = FightInformations[7]
	
	get_node("Table_Player1/Army_synthese").loadSynthesis(Heroes1, 
											Unit_IDs1, Unit_names1, Unit_InitialCounters1, 
											PlayerColor1, 1, remainingSquad)
	get_node("Table_Player2/Army_synthese").loadSynthesis(Heroes2, 
											Unit_IDs2, Unit_names2, Unit_InitialCounters2, 
											PlayerColor2, 2, remainingSquad)
	
	if Winner == 1:
		get_node("Label_Victory").rect_global_position.x -= 320
	elif Winner == 2:
		get_node("Label_Victory").rect_global_position.x += 320