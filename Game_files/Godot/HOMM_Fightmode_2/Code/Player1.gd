extends Sprite

var displacement : 			int = 4
var initiative : 			float = 5.0

onready var Player2 = get_node("Player2")
onready var Scene = get_parent()
var half_tile_size : 		int = 24

var is_active : 			bool= false
var calculate_priority : 	bool= false

#var speed : = 0
var target : 				Vector2 = Vector2()
var last_position : 		Vector2 = Vector2()
#var move_direction : = Vector2()

var priority : float

var Disp_Tiles = load("res://Scenes/Import_objects/Ground_Tiles.tscn")
var Target_Tile = load("res://Scenes/Import_objects/Ground_Tile_target.tscn")

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
		if Scene.PRIORITIES.Prio_player1 > Scene.PRIORITIES.Prio_player2:
			draw_displacement_tiles()
			is_active = true
		
	# calculate priority
	if event.is_action_pressed('ui_leftclic') and is_active==false:
		priority += initiative/2

