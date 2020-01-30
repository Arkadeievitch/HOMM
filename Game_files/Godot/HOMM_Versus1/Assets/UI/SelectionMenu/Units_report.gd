extends Control

func GenerateArmySummary(input_Unit_names, input_Unit_counters):
	
	# display Units counters, names and icons
	var Unit_names = 	[]
	var Unit_counters = []
	var output = SetUnitArrays(Unit_names, Unit_counters, 
								input_Unit_names, input_Unit_counters)
	Unit_names = 	output[0]
	Unit_counters = output[1]
	
	var NumberOfUnits = Unit_names.size()
	
	# pré-requis : un node 2D nommé "Units" contient les labels et icones des unités
	for i in NumberOfUnits:
		var unit_template = load("res://Assets/UI/SelectionMenu/UnitSelection/Label_Unit.tscn")
		# warning-ignore:void_assignment
		var new_child = unit_template.instance()
		add_child(new_child, true)
		
		new_child.text = Unit_names[i]
		new_child.get_node("UnitCounter").text = String(Unit_counters[i])
		new_child.global_position = [600, 350+(i+64)*128]
		
		var UnitIconDisplayed = load("res://Assets/Units/"&& 
									Unit_names[i] &&"/"&& Unit_names[i] && ".tscn")
		# warning-ignore:void_assignment
		new_child = add_child(UnitIconDisplayed.instance(), true)
		
		new_child.position = [256, 0]

func clearCurrentChildren():
	for i in get_child_count():
		get_child(i).queue_free()

func SetUnitArrays(internal_Unit_names, internal_Unit_counters,
					input_Unit_names, input_Unit_counters):
	internal_Unit_names = []
	internal_Unit_counters = []
	for i in input_Unit_names.size():
		if input_Unit_names[i] != null && input_Unit_counters[i] > 0 :
			internal_Unit_names.append(0)
			internal_Unit_names[i] = input_Unit_names[i]
			internal_Unit_counters.append(0)
			internal_Unit_counters[i] = input_Unit_counters[i]
		
	return [internal_Unit_names, internal_Unit_counters]