extends Node2D

class_name Fighter

var Priority : float = 0.0
var is_active : bool = false

var STATS

var Disp_Tiles = load("res://Resources/Ground_Tiles.tscn")
#var Target_Tile = load("res://Resources/Ground_Tile_target.tscn")

#_________________________________
func _ready():
	STATS = get_node("Character/Stats")
	Priority = STATS.INITIATIVE
	
	if get_node("/root/Battlefield") != null:
		$".".connect("Priorities_calculated", self, "_input")

#_________________________________
func _input(event):
	
	if Input.is_action_just_pressed("ui_leftclic"):
		
		if get_node("/root/Battlefield") != null:
			yield(get_parent(), "Priorities_calculated")
			if is_active == true:
				pass
			else:
				Priority += float(STATS.INITIATIVE) / float(get_parent().Char_number)
