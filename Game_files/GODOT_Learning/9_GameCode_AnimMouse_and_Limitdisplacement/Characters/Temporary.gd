extends Position2D

var TURN
var STATS
var displacement_allowed : bool = false
var Disp_Tiles = load("res://Resources/Ground_Tiles.tscn")

func _ready():
	STATS = get_parent().get_node("icon/Stats")
	TURN = get_node("/root/Battlefield/Turn")
		
func _input(event):
	if Input.is_action_just_pressed("ui_leftclic") && displacement_allowed == true:
		Delete_all_displacement_tiles()
	displacement_allowed = false
		
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
	if (TURN != null 
	&& TURN.is_connected("Priorities_retrieved", self, "Draw_displacement_tiles") == false) :
		TURN.connect("Priorities_retrieved", self, "Draw_displacement_tiles")
	
#___SIG 1___
func Draw_displacement_tiles():

	var new_tile
	var tile_size : int = 64
	
	var Characters_positions = []
	var Character_number = TURN.get_child_count()
	
	if get_parent().active_turn ==true:
		for i in Character_number:
			Characters_positions.append(0)
			Characters_positions[i] = TURN.get_child(i).position
		
		if STATS.DISPLACEMENT != 0:
			for n in range(-STATS.DISPLACEMENT, STATS.DISPLACEMENT+1):
				for m in range(-STATS.DISPLACEMENT, STATS.DISPLACEMENT+1):
					new_tile = Disp_Tiles.instance()
					add_child(new_tile, true)
					
					new_tile.position = Vector2(n*tile_size, 
												m*tile_size)
					
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
					
					for i in Character_number:
						if abs(self.global_position.x + tile_size*n - Characters_positions[i].x) <5:
							if abs(self.global_position.y + tile_size*m - Characters_positions[i].y) <5:
								new_tile.queue_free()
		else:
			print("DISPLACEMENT = 0")

func allowing_movement():
	displacement_allowed = true