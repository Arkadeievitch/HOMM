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
#func _process(delta):
#	yield(get_parent(), "Priorities_calculated")
#	if is_active==true:
#		draw_displacement_tiles()
	
#_________________________________
func _input(event):
	# Play if unit has highest priority (defined in Turn_Characters node) 
	# and increment priority otherwise.
	if Input.is_action_just_pressed("ui_leftclic"):
		
		if get_node("/root/Battlefield") != null:
			yield(get_parent(), "Priorities_calculated")
		
			if is_active == true:
				Priority = 0.0
				is_active = false
	#			delete_displacement_tiles()
			else:
				Priority += float(STATS.INITIATIVE) / float(get_parent().Char_number)
			
			
			
			
#_________________________________
#func draw_displacement_tiles():
#
#	var new_tile
#	var half_tile_size : int = 24
#
#	for n in range(-STATS.DISPLACEMENT, STATS.DISPLACEMENT+1):
#		for m in range(-STATS.DISPLACEMENT, STATS.DISPLACEMENT+1):
#			new_tile = Disp_Tiles.instance()
#			add_child(new_tile, true)
#
#			new_tile.position = Vector2(n*half_tile_size*2, m*half_tile_size*2)

