extends Position2D

var TURN
var STATS
var MOUSE

#var displacement_allowed : bool = false
var Disp_Tiles = load("res://Scenes/FIGHTMODE/B_Fightmode/Resources/Temporary_Tiles/Ground_Tiles.tscn")
#var Tempo_Tiles = load("res://Assets/UI/Fightmode/Temporary_Tiles/Ground_Tiles.tscn")
var Active_Border = load("res://Scenes/FIGHTMODE/B_Fightmode/Resources/Active_Border/Active_Border.tscn")

var drawnTempoTiles : bool = false

var TilesColor

func _ready():
	TilesColor = Color(1,1,1,1)
	getNodesfromTree()

# warning-ignore:unused_argument
func _process(delta):
	if (abs(self.global_position.x - MOUSE.global_position.x) < 30
	&& abs(self.global_position.y - MOUSE.global_position.y) < 30):
		
		if drawnTempoTiles == false && get_parent().active_turn == false:
			drawnTempoTiles = true
			drawTempoDisplacementTiles()
	else:
		if drawnTempoTiles == true && get_parent().active_turn == false:
			drawnTempoTiles = false
			deleteDisplacementTiles()

func getNodesfromTree():
	STATS = get_parent().get_node("icon/Stats")
	TURN = get_node("/root/MainNode/Battlefield/Turn")
	MOUSE = get_node("/root/MainNode/Battlefield/Mouse_Cursor")
#	TURN = get_node("/root/Battlefield/Turn")
#	MOUSE = get_node("/root/Battlefield/Mouse_Cursor")
		
func drawDisplacementTiles():

	var new_tile
	var tile_size : int = 64
	
	var Characters_positions = []
	var Character_number = TURN.get_child_count()
	
	if get_parent().active_turn == true:
		var add_child = Active_Border.instance()
		add_child(add_child, true)
		add_child.z_as_relative = false
		add_child.z_index = get_parent().z_index+1
		
		for i in Character_number:
			Characters_positions.append(0)
			Characters_positions[i] = TURN.get_child(i).position
		
		if STATS.DISPLACEMENT != 0:
			for n in range(-STATS.DISPLACEMENT, STATS.DISPLACEMENT+1):
				for m in range(-STATS.DISPLACEMENT, STATS.DISPLACEMENT+1):
					new_tile = Disp_Tiles.instance()
					add_child(new_tile, true)
					
					new_tile.modulate = TilesColor
					new_tile.position = Vector2(n*tile_size, 
												m*tile_size)
					
					# Supprime les angles
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
					
					# Supprime si hors du terrain X[128 1024] Y[128 768]
					if (new_tile.global_position.x < 128 || new_tile.global_position.x > 1024
					|| new_tile.global_position.y < 128 || new_tile.global_position.y > 768):
						new_tile.queue_free()
					
					for i in Character_number:
						if abs(self.global_position.x + tile_size*n - Characters_positions[i].x) <16:
							if abs(self.global_position.y + tile_size*m - Characters_positions[i].y) <16:
								new_tile.queue_free()
		else:
			print("DISPLACEMENT = 0")
			
func drawTempoDisplacementTiles():
	var new_tile
	var tile_size : int = 64
	
	var Characters_positions = []
	var Character_number = TURN.get_child_count()
	
	if get_parent().active_turn == false:
		var add_child = Active_Border.instance()
		add_child(add_child, true)
		add_child.modulate = Color(0, 0, 0, .9)
		
		for i in Character_number:
			Characters_positions.append(0)
			Characters_positions[i] = TURN.get_child(i).position
		
		if STATS.DISPLACEMENT != 0:
			for n in range(-STATS.DISPLACEMENT, STATS.DISPLACEMENT+1):
				for m in range(-STATS.DISPLACEMENT, STATS.DISPLACEMENT+1):
					new_tile = Disp_Tiles.instance()
					add_child(new_tile, true)
					
					new_tile.modulate = TilesColor
					
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
	