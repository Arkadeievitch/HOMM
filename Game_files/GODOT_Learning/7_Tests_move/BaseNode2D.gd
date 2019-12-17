extends Node2D

var TWEENS = []

func _ready():
	for i in get_child_count():
		TWEENS.append(0)
		TWEENS[i] = get_child(i).get_node("Tween")
	
func _process(delta):
	for i in TWEENS.size():
		if TWEENS[i].is_active()==true:
			print("active_Tween")