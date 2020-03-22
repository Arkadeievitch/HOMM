extends Node

var Top_BG

var Tile_0
var Tile_1
var Tile_2
var Tile_3

func load_BG(BF_name):
	var BG_path = str("res://Scenes/FIGHTMODE/B_Fightmode/Resources/Background/", BF_name)
	
	Top_BG = load(str(BG_path, "/BG_top_landscape.tscn"))
	
	Tile_0 = load(str(BG_path, "/BG_0.tscn"))
	Tile_1 = load(str(BG_path, "/BG_1.tscn"))
	Tile_2 = load(str(BG_path, "/BG_2.tscn"))
	Tile_3 = load(str(BG_path, "/BG_3.tscn"))

func Draw_Background(ChosenBattlefield):
	
	load_BG(ChosenBattlefield)
	
	var BoardResolution = Vector2(16, 8)
	#
	var top_landscape = Top_BG.instance()
	add_child(top_landscape, true)
	
	draw_BaseGround(BoardResolution)
	
	add_randomElements(50, Tile_1, BoardResolution)
	add_randomElements(14, Tile_2, BoardResolution)
	add_randomElements(10, Tile_3, BoardResolution)

func draw_BaseGround(internal_BoardResolution):
	for n in internal_BoardResolution.x:
		for m in internal_BoardResolution.y:
			var new_tile = Tile_0.instance()
			add_child(new_tile, true)
			new_tile.global_position = Vector2(128*n+64,
												128*m+64)
			new_tile.z_as_relative = false
			new_tile.z_index = 0

func add_randomElements(Tile_number, Tile_Scene, internal_BoardResolution):
	var random_integer_x
	var random_integer_y
	
	for i in Tile_number:
		random_integer_x = randi() % (int(internal_BoardResolution.x))
		random_integer_y = randi() % (int(internal_BoardResolution.y))
		var new_tile = Tile_Scene.instance()
		add_child(new_tile, true)
		new_tile.global_position = Vector2(128*random_integer_x+32,
											128*random_integer_y+32)
		new_tile.z_as_relative = false
		new_tile.z_index = 1