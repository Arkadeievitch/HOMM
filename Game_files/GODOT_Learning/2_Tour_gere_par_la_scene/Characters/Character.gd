extends Node2D

class_name Fighter

var Priority : float = 0.0
var is_active : bool = false

var FIGHTERS
var test
var STATS

func _ready():
	STATS = get_node("Character/Stats")
	Priority = STATS.INITIATIVE
	
	$".".connect("Priorities_calculated", self, "_input")


func _input(event):
	# Play if unit has highest priority (defined in Turn_Characters node) and increment priority otherwise.
	if Input.is_action_just_pressed("ui_leftclic"):
		
		yield(get_parent(), "Priorities_calculated")
		
		if is_active == true:
			Priority = 0.0
			is_active = false
		else:
			Priority += float(STATS.INITIATIVE) / float(get_parent().Char_number)
			