var drawnTempoTiles : bool = false

func _process(delta):
	if (abs(self.global_position.x - MOUSE.global_position.x) < 30
	&& abs(self.global_position.y - MOUSE.global_position.y) < 30):
		if drawnTempoTiles == false:
			drawnTempoTiles = true
			drawTempoDisplacementTiles()
	else:
		if drawnTempoTiles == true:
			drawnTempoTiles = false
			deleteDisplacementTiles()

# A placer dans drawDisplacementTiles et drawTempoDisplacementTiles
# for i in get_child_count():
#	if STATS.SIDE == 0:
# 		get_child(i).modulate = Color(0, 0, 1)
#	elif STATS.SIDE == 1:
# 		get_child(i).modulate = Color(1, 0, 0)
#	elif STATS.SIDE == 2:
# 		get_child(i).modulate = Color(0, 0, 0)