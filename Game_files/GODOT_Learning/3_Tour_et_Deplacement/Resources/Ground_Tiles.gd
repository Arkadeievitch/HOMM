extends Node2D

var Disp_Tiles_target = load("res://Resources/Ground_Tile_target.tscn")

func _ready():
	
	pass 
	
func _process(delta):
	
	
	
	pass


func draw_target_tile():

	var target_tile
	var half_tile_size : int = 24
	var target_position
	
	target_tile = Disp_Tiles_target.instance()
	add_child(target_tile, true)
	target_tile.position = target_position