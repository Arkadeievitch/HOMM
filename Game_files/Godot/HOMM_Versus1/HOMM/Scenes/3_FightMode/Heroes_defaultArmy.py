# fonctions attachées à chaque armée de héros.
extends Node2D

export var Unit_name1 : String
export var Unit_counter1 : int
export var Unit_name2 : String
export var Unit_counter2 : int
export var Unit_name3 : String
export var Unit_counter3 : int
export var Unit_name4 : String
export var Unit_counter4 : int
export var Unit_name5 : String
export var Unit_counter5 : int
export var Unit_name6 : String
export var Unit_counter6 : int

var SelectionMenu : bool = false
var Fightmode : 	bool = false

func _ready():
	if get_node("/root/MainNode/SelectionMenu") != null:
		SelectionMenu = true
		Fightmode = false
	elif get_node("/root/MainNode/Battlefield") != null:
		SelectionMenu = false
		Fightmode = true

func _input(event):
	if Input.is_action_just_pressed("ui_leftclic"):
		if SelectionMenu == true:
			clearCurrentChildren()
			HeroesSelected()

func HeroesSelected():
	if (abs(get_local_mouse_position.x) < 32
	&& abs(get_local_mouse_position.y) < 32):
		# move Heroes icon to its expected position
		get_parent().scale = Vector2(2, 2)
		get_parent().position = Vector2(64, 64)
		
		# display Units counters, names and icons
		var Unit_names = 	[]
		var Unit_counters = []
		var output = SetUnitArrays(Unit_names, Unit_counters)
		Unit_names = 	output[0]
		Unit_counters = output[1]
		
		var NumberOfUnits = UnitsName.size()
		
		# pré-requis : un node 2D nommé "Units" contient les labels et icones des unités
		var UNIT_DISPLAY = get_parent().get_parent().get_node("Units")
		for i in NumberOfUnits:
			var unit_template = load("/root/Assets/UI/SelectionMenu/UnitSelection.tscn")
			var new_child = add_child(unit_template.instance(), true)
			
			new_child.text = Unit_names[i]
			new_child.get_node("Counter").text = Unit_counters[i]
			new_child.global_position = Vector2(600, 350+(i+64)*128)
			
			var UnitIconDisplayed = load("/root/Assets/Units/"&& 
										Unit_names[i] &&"/"&& Unit_names[i] && ".tscn")
			new_child = add_child(UnitIconDisplayed.instance(), true)
			
			new_child.position = Vector2(256, 0)
	else:
		# remove if not selected
		get_parent().queue_free()

func SetUnitArrays(internal_Unit_names, internal_Unit_counters):
	if Unit_name1 != null && Unit_counter1 != null :
		internal_Unit_names.append(0)
		internal_Unit_names[0] = Unit_name1
		internal_Unit_counters.append(0)
		internal_Unit_counters = Unit_counter1
	if Unit_name2 != null && Unit_counter2 != null :
		internal_Unit_names.append(0)
		internal_Unit_names[0] = Unit_name2
		internal_Unit_counters.append(0)
		internal_Unit_counters = Unit_counter2
	if Unit_name3 != null && Unit_counter3 != null :
		internal_Unit_names.append(0)
		internal_Unit_names[0] = Unit_name3
		internal_Unit_counters.append(0)
		internal_Unit_counters = Unit_counter3
	if Unit_name4 != null && Unit_counter4 != null :
		internal_Unit_names.append(0)
		internal_Unit_names[0] = Unit_name4
		internal_Unit_counters.append(0)
		internal_Unit_counters = Unit_counter4
	if Unit_name5 != null && Unit_counter5 != null :
		internal_Unit_names.append(0)
		internal_Unit_names[0] = Unit_name5
		internal_Unit_counters.append(0)
		internal_Unit_counters = Unit_counter5
	if Unit_name6 != null && Unit_counter6 != null :
		internal_Unit_names.append(0)
		internal_Unit_names[0] = Unit_name6
		internal_Unit_counters.append(0)
		internal_Unit_counters = Unit_counter6
		
	return [internal_Unit_names, internal_Unit_counters]

clearCurrentChildren():
	get_child(0).queue_free()