extends Sprite

func _ready():
	if has_node("/root/MainNode/Battlefield"):
		yield(get_tree(), "idle_frame")
		
		if self.global_position.x < get_viewport().size.x/2:
			pass
		else:
			self.scale.x = -1
			
func onAction(TargetCharacterPosition, Tile_Position):
	if has_node("/root/MainNode/Battlefield") && TargetCharacterPosition!= null:
		yield(get_tree(), "idle_frame")
		if Tile_Position.x - TargetCharacterPosition.x < 0:
			self.scale.x = 1
		else:
			self.scale.x = -1