extends Position2D

var STATS
var Disp_Tiles = load("res://Resources/Ground_Tiles.tscn")

func _ready():
	STATS = get_parent().get_node("icon/Stats")
	
func _input(event):
	if Input.is_action_just_pressed("ui_leftclic"):
		Delete_all_displacement_tiles()
		
#================================================================
#___1___
func Delete_all_displacement_tiles(): 
	var all_children
	all_children = get_children() 

	if get_child_count()!=0:
		for i in range(0, get_child_count(), 1):
			all_children[i].queue_free()
		
#===SIGNALS FUNCTIONS==================================================
#___CONNECT___
func connect_Temporary_to_signals():
	var TURN = get_node("/root/Battlefield/Turn")
	if (TURN != null 
	&& TURN.is_connected("Priorities_retrieved", self, "Draw_displacement_tiles") == false) :
		TURN.connect("Priorities_retrieved", self, "Draw_displacement_tiles")
	
#___SIG 1___
func Draw_displacement_tiles():

	var new_tile
	var half_tile_size : int = 32
	
	if get_parent().active_turn ==true:
		if STATS.DISPLACEMENT != 0:
			for n in range(-STATS.DISPLACEMENT, STATS.DISPLACEMENT+1):
				for m in range(-STATS.DISPLACEMENT, STATS.DISPLACEMENT+1):
					new_tile = Disp_Tiles.instance()
					add_child(new_tile, true)
					
					new_tile.position = Vector2(n*2*half_tile_size, 
						m*2*half_tile_size)
					
					if n==0 && m==0:
						new_tile.queue_free()
					if n==STATS.DISPLACEMENT && m==-STATS.DISPLACEMENT:
						new_tile.queue_free()
					if n==STATS.DISPLACEMENT && m==STATS.DISPLACEMENT:
						new_tile.queue_free()
					if n==-STATS.DISPLACEMENT && m==-STATS.DISPLACEMENT:
						new_tile.queue_free()
					if n==-STATS.DISPLACEMENT && m==STATS.DISPLACEMENT:
						new_tile.queue_free()
						
		else:
			print("DISPLACEMENT = 0")