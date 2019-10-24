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
func is_cell_vacant(pos, direction):
# Return True if the cell is vacant and False otherwise
	var grid_pos = world_to_map(pos) + direction
	if grid_pos.x < grid_size.x and grid_pos.x >= 0:
		if grid_pos.y < grid_size.y and grid_pos.y >= 0:
			return true if grid[grid_pos.x][grid_pos.y] ==null else false
	return false
		
		
#_______________________________________________
func update_child_pos(child):
# Move a child to a new position in the grid array
# Returns the new target world postion of the child
	var grid_pos = world_to_map(child.position)
	print(grid_pos)
	grid[grid_pos.x][grid_pos.y] = null
	
	var new_grid_pos = grid_pos + child.direction # .direction NOT WORKING!
	grid[new_grid_pos.x][new_grid_pos.y] = child
	
	var target_pos = map_to_world(new_grid_pos) + half_tile_size
	return target_pos