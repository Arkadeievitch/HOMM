extends Position2D
#
var STATS

var Disp_Tiles = load("res://Resources/Ground_Tiles.tscn")


#_________________________________
func _ready():
	STATS = get_parent().get_node("icon/Stats")
	
	if get_node("/root/Battlefield") != null:
		$".".connect("Priorities_calculated", self, "_input")
		$".".connect("End_of_Displacement", self, "_input")
	
		yield(get_parent().get_parent(), "Priorities_calculated")
		if get_parent().is_active ==true:
			draw_displacement_tiles()
	

#_________________________________
func _input(event):
	if Input.is_action_just_pressed("ui_leftclic"):
		if get_child_count()!=0:
			delete_all_displacement_tiles()
			
		if get_node("/root/Battlefield") != null:
			yield(get_parent(), "End_of_Displacement")
			if get_parent().is_active ==true:
				draw_displacement_tiles()


#================================================================
#_________________________________
func draw_displacement_tiles():

	var new_tile
	var half_tile_size : int = 24
	
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
		
#_________________________________
func delete_all_displacement_tiles(): 
	var all_children

	all_children = get_children() 

	var i : = 0

	for i in range(0, get_child_count(), 1):
		all_children[i].queue_free()
		