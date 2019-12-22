extends Sprite

signal movement_allowed

func _ready():
	self.connect("movement_allowed", get_parent().get_parent().get_parent(), "allowing_movement")
	self.connect("movement_allowed", get_parent().get_parent(), "allowing_movement")

func _process(delta):
	emit_signal("movement_allowed")