extends Sprite

var Target_Tile = load("res://Resources/Ground_Tile_target.tscn")

func _process(delta):
	if abs(get_local_mouse_position().x) <= 30 :
		if abs(get_local_mouse_position().y) <= 30 :
			if get_child_count()==0:
				add_child(Target_Tile.instance(), true)
	#			hide()
			else:
				if get_child_count()>0:
					get_child(0).queue_free()
	#			show()
		else:
			if get_child_count()>0:
				get_child(0).queue_free()
#		show()
		