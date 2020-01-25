extends Node

var Tile_Grass0 = load("res://Background/Plaine/BG_Grass0.tscn")
var Tile_Grass1 = load("res://Background/Plaine/BG_Grass1.tscn")
var Tile_Grass2 = load("res://Background/Plaine/BG_Grass2.tscn")
var Tile_Grass3 = load("res://Background/Plaine/BG_Grass3.tscn")

func _ready():
	Draw_Background()

func Draw_Background():
	var BoardResolution = Vector2(12, 8)
	draw_BaseGround(BoardResolution)
	add_randomElements(BoardResolution)
	

func draw_BaseGround(internal_BoardResolution):
	
	for n in internal_BoardResolution.x:
		for m in internal_BoardResolution.y:
			var new_tile = Tile_Grass0.instance()
			add_child(new_tile, true)
			new_tile.global_position = Vector2(128*n+64,
												128*m+64)
			new_tile.z_as_relative = false
			new_tile.z_index = 0

func add_randomElements(internal_BoardResolution):
	var random_integer_x
	var random_integer_y
		
	# Placer tuiles de rang 1
	for i in 50:
		random_integer_x = randi() % (int(internal_BoardResolution.x))
		random_integer_y = randi() % (int(internal_BoardResolution.y))
		var new_tile = Tile_Grass1.instance()
		add_child(new_tile, true)
		new_tile.global_position = Vector2(128*random_integer_x+64,
											128*random_integer_y+64)
		new_tile.z_as_relative = false
		new_tile.z_index = 1
		print("Tile position ", new_tile.global_position)
		
	# Placer tuiles de rang 2
	for i in 14:
		random_integer_x = randi() % (int(internal_BoardResolution.x))
		random_integer_y = randi() % (int(internal_BoardResolution.y))
		var new_tile = Tile_Grass2.instance()
		add_child(new_tile, true)
		new_tile.global_position = Vector2(128*random_integer_x+64,
											128*random_integer_y+64)
		new_tile.z_as_relative = false
		new_tile.z_index = 1
		print("Tile position ", new_tile.global_position)
		
	# Placer tuiles de rang 3
	for i in 10:
		random_integer_x = randi() % (int(internal_BoardResolution.x))
		random_integer_y = randi() % (int(internal_BoardResolution.y))
		var new_tile = Tile_Grass3.instance()
		add_child(new_tile, true)
		new_tile.global_position = Vector2(128*random_integer_x+64,
											128*random_integer_y+64)
		new_tile.z_as_relative = false
		new_tile.z_index = 1
		print("Tile position ", new_tile.global_position)