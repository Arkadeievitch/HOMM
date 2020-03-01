extends Node

var Obstacle1 = load("res://Scenes/FIGHTMODE/B_Fightmode/Resources/Obstacles/Plaine/OBS_Plaine1.tscn")

var BoardResolution = Vector2(10, 6)
export var Obstacle1_number : int = 2

func _ready():
	Draw_Obstacles(Obstacle1_number, Obstacle1)

func Draw_Obstacles(Tile_number, Tile_Scene):
	var random_integer_x
	var random_integer_y
	
	for i in Tile_number:
		if get_child_count()>0:
			random_integer_x = randi() % (int(BoardResolution.x))
			random_integer_y = randi() % (int(BoardResolution.y))
			
			makeUniquePosition(random_integer_x, random_integer_y)
		else:
			random_integer_x = randi() % (int(BoardResolution.x))
			random_integer_y = randi() % (int(BoardResolution.y))
			
			
		var new_tile = Tile_Scene.instance()
		add_child(new_tile, true)
		new_tile.global_position = Vector2(64*random_integer_x+480,
											64*random_integer_y+256)
		new_tile.z_as_relative = false
		new_tile.z_index = 2

func makeUniquePosition(random_integer_x, random_integer_y):
	var x_position = 64*random_integer_x+480
	var y_position = 64*random_integer_y+256
	var value_changed : bool = false
	for j in get_child_count():
		if (get_child(j).global_position.x - x_position <32
		&& get_child(j).global_position.y - y_position <32):
			random_integer_x = randi() % (int(BoardResolution.x))
			random_integer_y = randi() % (int(BoardResolution.y))
			x_position = 64*random_integer_x+480
			y_position = 64*random_integer_y+256
			value_changed = true
	
	if value_changed == true:
		makeUniquePosition(random_integer_x, random_integer_y)