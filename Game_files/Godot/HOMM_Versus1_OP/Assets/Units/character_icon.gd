extends Sprite

func _ready():
	if has_node("/root/MainNode/Battlefield"):
		yield(get_tree(), "idle_frame")
		
		if self.global_position.x < get_viewport().size.x/2:
			pass
		else:
			self.scale.x = -1
			
func onAction(TargetCharacterPosition, TileTargetPosition):
	if has_node("/root/MainNode/Battlefield"):
		yield(get_tree(), "idle_frame")
		if TileTargetPosition.x - TargetCharacterPosition.x < 0:
			self.scale.x = 1
		else:
			self.scale.x = -1