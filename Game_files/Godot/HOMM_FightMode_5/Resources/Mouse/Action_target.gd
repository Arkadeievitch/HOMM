extends Sprite

var MOUSE

func _ready():
	MOUSE = get_parent()

# warning-ignore:unused_argument
func _process(delta):
	self.global_position = MOUSE.Action_target

