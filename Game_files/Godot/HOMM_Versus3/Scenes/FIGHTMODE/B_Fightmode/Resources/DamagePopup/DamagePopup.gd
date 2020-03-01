extends Label

func _ready():
	self.visible = true
	# warning-ignore:return_value_discarded
	get_node("Timer").connect("timeout", self, "selfDelete")

func selfDelete():
	self.queue_free()