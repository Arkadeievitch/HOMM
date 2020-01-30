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

var Unit_names = []
var Unit_counters = []

func _ready():
	Unit_names = [	Unit_name1, Unit_name2, Unit_name3, 
					Unit_name4, Unit_name5, Unit_name6]
	Unit_counters = [	Unit_counter1, Unit_counter2, Unit_counter3,
						Unit_counter4, Unit_counter5, Unit_counter6]
	if get_node("/root/MainNode/SelectionMenu") != null:
		SelectionMenu = true
		Fightmode = false
	elif get_node("/root/MainNode/Battlefield") != null:
		SelectionMenu = false
		Fightmode = true

# warning-ignore:unused_argument
func _input(event):
	if Input.is_action_just_pressed("ui_leftclic"):
		if SelectionMenu == true:
			clearCurrentChildren()
			HeroesSelected()

func HeroesSelected():
	if (abs(get_local_mouse_position().x) < 32
	&& abs(get_local_mouse_position().y) < 32):
		# move Heroes icon to its expected position
		get_parent().scale = Vector2(2, 2)
		get_parent().position = Vector2(64, 64)
		
		var UNITS = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("Units_Report")
		UNITS.GenerateArmySummary(Unit_names, Unit_counters)
		
	else:
		# remove if not selected
		get_parent().queue_free()

func clearCurrentChildren():
	if get_child_count() > 0:
		get_child(0).queue_free()