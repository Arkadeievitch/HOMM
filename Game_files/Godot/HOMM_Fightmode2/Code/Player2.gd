extends Sprite

var displacement : 			int = 5
var initiative : 			float = 4.0

onready var Player1 = get_node("Player1")
onready var Scene = get_parent()
var half_tile_size : 		int = 24

var is_active : 			bool = false
var calculate_priority : 	bool = false

#var speed : = 0
var target : 		Vector2 = Vector2()
var last_position : Vector2 = Vector2()
#var move_direction : = Vector2()

var priority : float

var Disp_Tiles = 	load("res://Scenes/Import_objects/Ground_Tiles.tscn")
var Target_Tile = 	load("res://Scenes/Import_objects/Ground_Tile_target.tscn")

var new_tile
var all_tiles

signal player_ready

# ________________________________________________________________________________
# Called when the node enters the scene tree for the first time.
func _ready():
	priority = initiative
	set_process_input(true)

	emit_signal("player_ready")
	

# ________________________________________________________________________________
func _input(event):
		
	# apply displacement
	if event.is_action_pressed('ui_leftclic') and is_active==true:
		last_position = position
		target = Vector2(get_global_mouse_position().x, get_global_mouse_position().y)
		position = target
		
		all_tiles = get_children() # delete the displacement tiles
		var i : = 0
		for n in range(0, 2*displacement+1, 1):
			for m in range(0, 2*displacement+1, 1):
				all_tiles[i].queue_free()
				i += 1
		
		priority = 0
		calculate_priority = true
		is_active = false
		
	if event.is_action_pressed('ui_leftclic'):
		if Scene.PRIORITIES.Prio_player1 < Scene.PRIORITIES.Prio_player2:
			print("P1 turn")
			draw_displacement_tiles()
			is_active = true
		
	if event.is_action_pressed('ui_leftclic') and is_active==false:
		priority += initiative/2

# ________________________________________________________________________________
# Function to generate displacement tiles from player posiion
func draw_displacement_tiles():
	
	for n in range(-displacement, displacement+1):
		for m in range(-displacement, displacement+1):
			new_tile = Disp_Tiles.instance()
			add_child(new_tile)

			new_tile.position = Vector2(n*half_tile_size*2,
				m*half_tile_size*2)

func _on_scene_is_ready():
	if Scene.PRIORITIES.Prio_player1 < Scene.PRIORITIES.Prio_player2:
		draw_displacement_tiles()
		is_active = true