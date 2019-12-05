extends Position2D
#
var STATS

var Disp_Tiles = load("res://Resources/Ground_Tiles.tscn")

#_________________________________
func _ready():
	STATS = get_parent().get_node("Character/Stats")
	
	if get_node("/root/Battlefield") != null:
		self.connect("Priorities_calculated", get_node("/root/Battlefield/Turn_Characters"), "_input")
		yield(get_parent(), "Priorities_calculated")
		
		
	draw_displacement_tiles()


#_________________________________
func draw_displacement_tiles():

	var new_tile
	var half_tile_size : int = 12
	
	if STATS.DISPLACEMENT != 0:
		for n in range(-STATS.DISPLACEMENT, STATS.DISPLACEMENT+1):
			for m in range(-STATS.DISPLACEMENT, STATS.DISPLACEMENT+1):
				new_tile = Disp_Tiles.instance()
				add_child(new_tile, true)
				
				new_tile.position = Vector2(n*STATS.DISPLACEMENT*half_tile_size, 
					m*STATS.DISPLACEMENT*half_tile_size)
	else:
		print("DISPLACEMENT = 0")
		
#_________________________________
func delete_displacement_tiles(): 
	var all_children

	all_children = get_children() 

	var i : = 0

	for n in range(0, 2*STATS.DISPLACEMENT+1, 1):
		for m in range(0, 2*STATS.DISPLACEMENT+1, 1):
			all_children[i].queue_free()
			i += 1