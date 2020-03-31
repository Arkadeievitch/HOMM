extends Sprite

func _ready():
	if has_node("/root/MainNode/Battlefield"):
		if self.global_position.x > get_viewport().size.x/2:
			if self.scale.x <1.5:
				self.scale.x = -1

func onAction(TargetCharacterPosition, Tile_Position):
	if has_node("/root/MainNode/Battlefield") && TargetCharacterPosition!= null:
		if Tile_Position.x - TargetCharacterPosition.x < 1:
			self.scale.x = 1
		elif Tile_Position.x - TargetCharacterPosition.x > 1:
			self.scale.x = -1