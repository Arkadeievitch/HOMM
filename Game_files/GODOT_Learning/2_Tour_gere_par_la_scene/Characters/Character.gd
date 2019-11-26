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
	pass

func _process(delta):

	pass

func _input(event):
	
	if Input.is_action_pressed("ui_leftclic"): # ! Ne gère pas plusieurs joueurs ayant la même priorité
		
		if Priority == get_parent().Highest_priority:
			print(STATS.MAX_HP)
			Priority = 0.0
		else:
			Priority += float(STATS.INITIATIVE) / float(get_parent().Char_number)
			
	pass