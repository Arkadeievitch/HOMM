# fonctions attachées à chaque armée de héros.
extends Node2D

# warning-ignore:unused_class_variable
export var Unit_name1 : String
# warning-ignore:unused_class_variable
export var Unit_counter1 : int
# warning-ignore:unused_class_variable
export var Unit_name2 : String
# warning-ignore:unused_class_variable
export var Unit_counter2 : int
# warning-ignore:unused_class_variable
export var Unit_name3 : String
# warning-ignore:unused_class_variable
export var Unit_counter3 : int
# warning-ignore:unused_class_variable
export var Unit_name4 : String
# warning-ignore:unused_class_variable
export var Unit_counter4 : int
# warning-ignore:unused_class_variable
export var Unit_name5 : String
# warning-ignore:unused_class_variable
export var Unit_counter5 : int
# warning-ignore:unused_class_variable
export var Unit_name6 : String
# warning-ignore:unused_class_variable
export var Unit_counter6 : int

var SelectionMenu : bool = false
var Fightmode : 	bool = false

var Heroes_is_selected : bool = false

var Unit_names
var Unit_counters

func _ready():
	if has_node("/root/MainNode/SelectionMenu") == true:
		SelectionMenu = true
		Fightmode = false
	elif has_node("/root/MainNode/Battlefield") == true:
		SelectionMenu = false
		Fightmode = true

# warning-ignore:unused_argument
func _input(event):
	if Input.is_action_just_pressed("ui_leftclic"):
		HeroesSelected()

func HeroesSelected():
	if (abs(get_local_mouse_position().x) < 32
	&& abs(get_local_mouse_position().y) < 32):
		
		Heroes_is_selected = true
		removeUnselectedHeroes()
		Unit_names = [	Unit_name1, Unit_name2, Unit_name3, 
						Unit_name4, Unit_name5, Unit_name6]
		Unit_counters = [	Unit_counter1, Unit_counter2, Unit_counter3,
							Unit_counter4, Unit_counter5, Unit_counter6]
		# move Heroes icon to its expected position
		get_parent().scale = Vector2(2, 2)
		get_parent().position = Vector2(64, 64)
		# Generate the army report
		GenerateArmySummary(Unit_names, Unit_counters)
	else:
		Heroes_is_selected = false

func GenerateArmySummary(input_Unit_names, input_Unit_counters):
	# display Units counters, names and icons
	var output_Unit_names = 	[]
	var output_Unit_counters = []
	var output = SetUnitArrays(output_Unit_names, output_Unit_counters, 
								input_Unit_names, input_Unit_counters)
	output_Unit_names = 	output[0]
	output_Unit_counters = output[1]
	
	var NumberOfUnits = output_Unit_names.size()
	
	# pré-requis : un node 2D nommé "Units" contient les labels et icones des unités
	for i in NumberOfUnits:
		var unit_template = load("res://Assets/UI/VersusSelection/SelectionPanel/UnitsLabel/Label_Unit.tscn")
		# warning-ignore:void_assignment
		var new_child = unit_template.instance()
		add_child(new_child, true)
		
		new_child.text = output_Unit_names[i]
		new_child.get_node("UnitCounter").text = String(output_Unit_counters[i])
		new_child.rect_scale = Vector2(0.5, 0.5)
		new_child.rect_position = Vector2(80, 48*i-96)
		
		var UnitIconPath = str("res://Assets/Units/", output_Unit_names[i], "/icon.tscn") 
		var UnitIconDisplayed = load(UnitIconPath)
		# warning-ignore:void_assignment
		new_child = UnitIconDisplayed.instance()
		add_child(new_child, true)
		
		new_child.scale = Vector2(0.5, 0.5)
		new_child.position = Vector2(176, 48*i-16-64)

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

func removeUnselectedHeroes():
	var ALLHEROES = get_parent().get_parent()
	for i in ALLHEROES.get_child_count():
		var CurrentChild = get_parent().get_parent().get_child(i)
		if CurrentChild.has_node("defaultArmy") == true:
			if CurrentChild.get_node("defaultArmy").Heroes_is_selected == true:
				pass
			else:
				CurrentChild.queue_free()
		else:
			CurrentChild.queue_free()