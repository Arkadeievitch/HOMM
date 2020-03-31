extends Position2D

func loadUnitHunt(Unit_name, Unit_Hunt, PreyColor):
	
		var UnitIconPath = str("res://Assets/TSCN/Units/", Unit_name, "/icon.tscn")
		var UnitIconDisplayed = load(UnitIconPath)
		# warning-ignore:void_assignment
		var new_icon = UnitIconDisplayed.instance()
		add_child(new_icon, true)
		
		new_icon.scale = Vector2(2, 2)
		new_icon.get_node("BG_Gradient").modulate = get_parent().color
		
		for i in min(Unit_Hunt[0].size(), 7):
			UnitIconPath = str("res://Assets/TSCN/Units/", Unit_Hunt[0][i], "/icon.tscn")
			UnitIconDisplayed = load(UnitIconPath)
			new_icon = UnitIconDisplayed.instance()
			
			var currentPosition = str("Position", i+1)
			get_node(currentPosition).add_child(new_icon, true)
			new_icon.scale = Vector2(0.75, 0.75)
			new_icon.get_node("BG_Gradient").modulate = PreyColor
			
			get_node(currentPosition).get_node("Label_Kills").text = str(Unit_Hunt[1][i], " ", 
																		 Unit_Hunt[0][i], " killed")