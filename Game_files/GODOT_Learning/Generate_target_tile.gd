extends Sprite

var Target_Tile = load("res://Resources/Target_Tile.tscn")

func _process(delta):
	if abs(get_local_mouse_position().x) < 12 :
		if abs(get_local_mouse_position().y) < 12 :
			hide()
			add_child(Target_Tile.instance(), true)
		else:
			get_children().queue_free()
			show()
	else:
		get_children().queue_free()
		show()
