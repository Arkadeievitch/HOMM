extends ColorRect

func _ready():
	if has_node("/root/MainNode/Battlefield"):
		yield(get_tree(), "idle_frame")
		var TEMPORARY = get_parent().get_parent().get_node("Temporary")
		self.color = TEMPORARY.TilesColor
		
		var TURN = get_node("/root/MainNode/Battlefield/Turn")
		TURN.updateTurnChronology()