extends ColorRect # Appel depuis l'icone de l'unité.

var HuntingBoardTriggered : bool = false
var HuntingBoard_path : String = "res://Scenes/FIGHTMODE/C_Victory/Resources/TableaudeChasse/TableaudeChasse_Positions.tscn"

# warning-ignore:unused_argument
func _process(delta):
	var VICTORY_SCREEN : Node = get_node("/root/MainNode/VictoryScreen")
	var Icon_position : Vector2 = get_node("icon").global_position
	var Mouse_position : Vector2 = VICTORY_SCREEN.get_node("Mouse_Cursor/Mouse_Front").global_position
	
	if (abs(Mouse_position.x - Icon_position.x) < 32
	&& abs(Mouse_position.y - Icon_position.y) < 32):
		if HuntingBoardTriggered == false:
			HuntingBoardTriggered = true
			var HuntingBoard = []
			var Unit_ID
			var Unit_name : String
			var PreyColor : Color
			
			if get_child_count() > 0:
				Unit_ID = get_node("icon/Stats").Unit_ID
				if get_node("icon/Stats").SIDE == 1:
					HuntingBoard = VICTORY_SCREEN.HuntingBoard1.duplicate(true)
					PreyColor = VICTORY_SCREEN.PlayerColor2
				elif get_node("icon/Stats").SIDE == 2:
					HuntingBoard = VICTORY_SCREEN.HuntingBoard2.duplicate(true)
					PreyColor = VICTORY_SCREEN.PlayerColor1
			
			var Unit_Hunt = [[], []]
			for i in HuntingBoard[0].size():
				if HuntingBoard[0][i] == Unit_ID:
					Unit_name = HuntingBoard[1][i]
					Unit_Hunt = [HuntingBoard[2][i], HuntingBoard[3][i]]
					break
			
			var halfScreen = get_viewport().size.x/2
			if Icon_position.x < halfScreen:
				VICTORY_SCREEN.get_node("VictoryRecord/HuntBoard_R").visible = true
				VICTORY_SCREEN.get_node("Table_Player2").visible = false
				
				var hunting = load(HuntingBoard_path)
				hunting = hunting.instance()
				add_child(hunting, true)
				
				hunting.global_position = Vector2(get_viewport().size.x-352, 320)
				hunting.loadUnitHunt(Unit_name, Unit_Hunt, PreyColor)
				
			else:
				VICTORY_SCREEN.get_node("VictoryRecord/HuntBoard_L").visible = true
				VICTORY_SCREEN.get_node("Table_Player1").visible = false
				
				var hunting = load(HuntingBoard_path)
				hunting = hunting.instance()
				add_child(hunting, true)
				
				hunting.global_position = Vector2(320, 320)
				hunting.loadUnitHunt(Unit_name, Unit_Hunt, PreyColor)
		
		
	else:
		if HuntingBoardTriggered == true:
			if has_node("TableaudeChasse_Positions"):
				get_node("TableaudeChasse_Positions").queue_free()
			VICTORY_SCREEN.get_node("VictoryRecord/HuntBoard_R").visible = false
			VICTORY_SCREEN.get_node("VictoryRecord/HuntBoard_L").visible = false
			VICTORY_SCREEN.get_node("Table_Player1").visible = true
			VICTORY_SCREEN.get_node("Table_Player2").visible = true
			HuntingBoardTriggered = false