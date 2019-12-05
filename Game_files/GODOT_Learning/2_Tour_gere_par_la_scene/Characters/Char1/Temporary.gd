extends Position2D
#
#var STATS
#
#var Disp_Tiles = load("res://Resources/Ground_Tiles.tscn")
#
##_________________________________
#func _ready():
#	STATS = get_node("./Stats")
#
#	self.connect("Priorities_calculated", get_node("/root/Battlefield/Turn_Characters"), "_input")
#	yield(get_parent(), "Priorities_calculated")
#
#
##_________________________________
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