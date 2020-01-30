extends Node

func _ready():
	add_child(load("res://Selection_Menu/Selection_Menu.tscn").instance(), true)
	if get_child(0) != null:
		Button_Engage.connect("button_up", self, "load_Fightmode")

func load_Fightmode(Side, IA, TileColor, Units, Unit_counters): # appel bouton
	get_tree().change_scene("res://Fightmode/Fightmode.tscn")
	
	var TURN = get_node("Battlefield/Turn")
	
	var Unit_number = Units.size()
	for i in Unit_number:
		var new_unit = load(set_text("res://Characters/", string(Units[i]), ".tscn"))
		var CHARACTER = new_unit.instance()
		TURN.add_child(CHARACTER, true)
		
		var STATS = CHARACTER.get_node("icon/Stats")
		print(STATS.NAME) # controle du character
		var TEMPORARY = CHARACTER.get_node("Temporary")
		
		STATS.SIDE = Side[i]
		STATS.Player = IA[i]
		STATS.NUMBER = Unit_counters[i]
		
		TEMPORARY.TileColor = TileColor[i]
		
		if Side == 1:
			CHARACTER.global_position.x = 128
			CHARACTER.global_position.y = 64*(i%(Unit_number/2)+64)+128+32
		elif Side == 2:
			CHARACTER.global_position.x = 704
			CHARACTER.global_position.y = 64*(i%(Unit_number/2)+64)+128+32
		else: # Par défaut, on aligne les unités en haut de l'écran.
			CHARACTER.global_position.x = 256+64*i
			CHARACTER.global_position.y = 0

func load_Victory_Screen(Side, TileColor, Units, Unit_counters): # appel depuis Fightmode
	get_tree().change_scene("res://Victory_Screen/Victory_Screen.tscn")
	Button_ReturnMenu.connect("button_up", self, "load_Selection_Menu")

func load_Selection_Menu():	# appel bouton
	get_tree().change_scene("res://Selection_Menu/Selection_Menu.tscn")
	Button_Engage.connect("button_up", self, "load_Fightmode")