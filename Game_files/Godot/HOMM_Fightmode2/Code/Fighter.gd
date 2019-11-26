extends Position2D

class_name Fighter

#export var stats : Resource
onready var stats : UnitStats = $Unit_info/Stats as UnitStats

var half_tile_size : int = 24

func initialize():
	stats = stats.copy()

func play_turn(target : Fighter, action):
	draw_displacement_tiles()
#	yield(skin.move_forward(), "completed")
#	action.execute(self, target)
#	yield(skin.move_to(target), "completed")
#	yield(get_tree().create_timer(1.0), "timeout")
#	yield(skin.r"r"res://Resources/Actions.tres"es://Resources/Actions.tres"eturn_to_start(), "completed") # in example, return creature to initial position

# ________________________________________________________________________________
# Function to generate displacement tiles from player posiion
func draw_displacement_tiles():

	var Disp_Tiles = load("res://Scenes/Import_objects/Ground_Tiles.tscn")
	
	for n in range(-stats.Displacement, stats.Displacement+1):
		for m in range(-stats.Displacement, stats.Displacement+1):
			var new_tile = Disp_Tiles.instance()
			add_child(new_tile)

			new_tile.position = Vector2(n*half_tile_size*2,
				m*half_tile_size*2)
