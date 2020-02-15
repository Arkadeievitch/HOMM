extends Node2D

onready var Target_Tile = load("res://Assets/UI/Fightmode/Temporary_Tiles/Target_Tile.tscn")

var MOUSE

func _ready():
	MOUSE = get_node("/root/MainNode/Battlefield/Mouse/Mouse_Cursor")
	
# Show active tile or not
# warning-ignore:unused_argument
func _physics_process(delta):
	if abs(get_local_mouse_position().x+MOUSE.Tile_offset.x) <= 32:
		if abs(get_local_mouse_position().y+MOUSE.Tile_offset.y) <= 32:
			if get_child_count()==0:
				var add_child = Target_Tile.instance()
				add_child(add_child, true)
		else:
			if get_child_count()>0:
				get_child(0).queue_free()
	else:
		if get_child_count()>0:
			get_child(0).queue_free()
							