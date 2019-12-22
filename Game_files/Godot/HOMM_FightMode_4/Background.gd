extends Node

var Checker_Tiles = load("res://Resources/Checker_Tiles.tscn")
var onetwo : bool = false

#func _ready():
#	Draw_checker_tiles()
#	pass

#func Draw_checker_tiles():
#
#	var new_tile
#	var half_tile_size : int = 32
#
#	for n in 30:
#		for m in 15:
#			onetwo_alternate()
#			if onetwo == true:
#				new_tile = Checker_Tiles.instance()
#				add_child(new_tile, true)
#				new_tile.position = Vector2(n*2*half_tile_size+32, 
#											m*2*half_tile_size+32)
#
#func onetwo_alternate():
#	if onetwo == false:
#		onetwo = true
#	else:
#		onetwo = false