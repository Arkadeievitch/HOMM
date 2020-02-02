extends Sprite

var MOUSE

func _ready():
	MOUSE = get_parent()
	if MOUSE.Fightmode == true:
		self.offset = Vector2(0, 0)
		self.scale = Vector2(1, 1)
	else:
		self.offset = Vector2(-112, 112)
		self.scale = Vector2(0.5, 0.5)

# warning-ignore:unused_argument
func _process(delta):
	if MOUSE.Fightmode == true:
		self.global_position = MOUSE.Tile_target