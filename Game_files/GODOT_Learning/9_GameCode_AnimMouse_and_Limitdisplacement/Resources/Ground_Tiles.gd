extends Node2D

onready var Target_Tile = load("res://Resources/Ground_Tile_target.tscn")

var MOUSE

func _ready():
	MOUSE = get_node("/root/Battlefield/Mouse/Mouse_Cursor")
	
# Show active tile or not
func _physics_process(delta):
	if abs(get_local_mouse_position().x+MOUSE.Active_target.x) <32:
		if abs(get_local_mouse_position().y+MOUSE.Active_target.y) <32:
			if get_child_count()==0:
				var add_child = Target_Tile.instance()
				add_child(add_child, true)
		else:
			if get_child_count()>0:
				get_child(0).queue_free()
	else:
		if get_child_count()>0:
			get_child(0).queue_free()
							