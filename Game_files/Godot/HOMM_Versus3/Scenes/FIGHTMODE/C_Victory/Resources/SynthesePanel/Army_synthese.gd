extends Node2D
var LabelUnit_path : String = "res://Scenes/FIGHTMODE/A_SelectionMenu/Resources/SelectionPanel/UnitsLabel/Label_Unit.tscn"

func loadSynthesis(Heroes, Unit_Names, Unit_InitialCounters, PlayerColor):
	loadHeroesPortrait(Heroes, PlayerColor)
	
	loadArmyLabels(Unit_Names, Unit_InitialCounters, PlayerColor)

func loadHeroesPortrait(Heroes, PlayerColor):
	var heroesPath = str("res://Assets/TSCN/Heroes/", Heroes, "/", Heroes, ".tscn")
	var HeroesIcon = load(heroesPath).instance()
	
	get_parent().get_node("Color_Heroes").add_child(HeroesIcon, true)
	HeroesIcon.global_position = (get_parent().get_node("Color_Heroes").rect_global_position 
									+ Vector2(64, 64))
	HeroesIcon.scale = Vector2(2, 2)
	
	get_parent().get_node("Color_Heroes").color = PlayerColor

func loadArmyLabels(Unit_Names, Unit_InitialCounters, PlayerColor):
	
	for i in Unit_Names.size():
		var unit_template = load(LabelUnit_path)
		# warning-ignore:void_assignment
		var new_child = unit_template.instance()
		add_child(new_child, true)
		
		#Ecriture du nom et du compteur de l'unité
		new_child.text = Unit_Names[i]
		new_child.get_node("UnitCounter").text = String(Unit_InitialCounters[i])
		new_child.get_node("Unit_BG").color = PlayerColor
		new_child.rect_scale = Vector2(1, 1)
		new_child.rect_position = Vector2(128+80, 96*i-96)
		var BG_position = new_child.get_node("Unit_BG").rect_global_position
		
		#Importe l'icône de l'unité
		var UnitIconPath = str("res://Assets/TSCN/Units/", Unit_Names[i], "/icon.tscn") 
		var UnitIconDisplayed = load(UnitIconPath)
		# warning-ignore:void_assignment
		new_child = UnitIconDisplayed.instance()
		add_child(new_child, true)
		
		new_child.scale = Vector2(1, 1)
		new_child.global_position = BG_position + Vector2(32, 32)