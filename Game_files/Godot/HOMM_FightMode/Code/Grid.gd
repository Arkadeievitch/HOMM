extends TileMap

var tile_size = get_cell_size()
var half_tile_size = tile_size/2

enum ENTITY_TYPES {PLAYER, OBSTACLE}

var grid_size = Vector2(16,16)
var grid = []

onready var Obstacle = preload("res://Scenes/Obstacle.tscn")

#_______________________________________________
func _ready():

	# Create the grid Array
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null)
	pass

	# Generate obstacles
	var positions = []
	var n_obstacles = 5
	
	for n in range(n_obstacles):
		var grid_position = Vector2(randi() % int(grid_size.x), randi() % int(grid_size.y))
		if not grid_position in positions:
			positions.append(grid_position)
	
	for pos in positions:
		var new_obstacle = Obstacle.instance()
		new_obstacle.position = map_to_world(pos) + half_tile_size
		grid[pos.x][pos.y] = ENTITY_TYPES.OBSTACLE
		add_child(new_obstacle)


#_______________________________________________
# Return True if the cell is vacant and False otherwise
func is_cell_vacant():
	pass
	
#_______________________________________________
# Move a child to a new position in the grid array
# Returns the new target world postion of the child
func update_child_po(child, new_pos, direction):
	pass
	