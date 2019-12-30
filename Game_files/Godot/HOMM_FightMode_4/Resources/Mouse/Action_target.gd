extends Sprite

var MOUSE

func _ready():
	MOUSE = get_parent()

func _process(delta):
	self.global_position = MOUSE.Action_target

