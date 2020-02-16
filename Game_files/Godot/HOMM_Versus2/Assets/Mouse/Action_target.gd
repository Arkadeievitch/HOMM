extends Sprite

var MOUSE

func _ready():
	MOUSE = get_parent()
	if MOUSE.Fightmode == true:
		self.offset = Vector2(0, 0)
	else:
		self.offset = Vector2(-8, 8)

# warning-ignore:unused_argument
func _process(delta):
	if MOUSE.Fightmode == true:
		self.global_position = MOUSE.Action_target
