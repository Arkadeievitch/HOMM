extends Position2D

var TURN
var STATS
var MOUSE

#var displacement_allowed : bool = false
var Disp_Tiles = load("res://Resources/Tiles/Ground_Tiles.tscn")
var Active_Border = load("res://Resources/UI/Active_Border/Active_Border.tscn")

func _ready():
	getNodesfromTree()

# warning-ignore:unused_argument
#func _process(delta):
#	displacement_allowed = false
		
#================================================================
func getNodesfromTree():
	STATS = get_parent().get_node("icon/Stats")
	TURN = get_node("/root/Battlefield/Turn")
	MOUSE = get_node("/root/Battlefield/Mouse/Mouse_Cursor")
	
#===SIGNALS FUNCTIONS==================================================
#___CONNECT___ (Called by TURN)
#func connect_Temporary_to_signals():
#	if (TURN != null &&
#	TURN.is_connected("Priorities_retrieved", self, "drawDisplacementTiles") == false):
#		TURN.connect("Priorities_retrieved", self, "drawDisplacementTiles")
#	if (MOUSE != null &&
#	MOUSE.is_connected("mouse_clic", self, "deleteDisplacementTiles") == false):
#		MOUSE.connect("mouse_clic", self, "deleteDisplacementTiles")
		
func drawDisplacementTiles():

	var new_tile
	var tile_size : int = 64
	
	var Characters_positions = []
	var Character_number = TURN.get_child_count()
	
	if get_parent().active_turn == true:
		var add_child = Active_Border.instance()
		add_child(add_child, true)
		
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
						if abs(self.global_position.x + tile_size*n - Characters_positions[i].x) <16:
							if abs(self.global_position.y + tile_size*m - Characters_positions[i].y) <16:
								new_tile.queue_free()
		else:
			print("DISPLACEMENT = 0")

func deleteDisplacementTiles(): 
	var all_children
	all_children = get_children() 
	
	for i in range(0, get_child_count(), 1):
		all_children[i].queue_free()
	
# warning-ignore:unused_argument
#func allowing_movement(Tile_position):
#	displacement_allowed = true
	
	