extends Sprite

func _ready():
	connect_to_rotations()

# warning-ignore:unused_argument
func _process(delta):
	self.rotation_degrees = 0
	
func connect_to_rotations():
# warning-ignore:return_value_discarded
	get_parent().get_child(1).connect("rotate_1", self, "rotation_1")
# warning-ignore:return_value_discarded
	get_parent().get_child(2).connect("rotate_2", self, "rotation_2")
# warning-ignore:return_value_discarded
	get_parent().get_child(3).connect("rotate_3", self, "rotation_3")
# warning-ignore:return_value_discarded
	get_parent().get_child(4).connect("rotate_4", self, "rotation_4")
# warning-ignore:return_value_discarded
	get_parent().get_child(5).connect("rotate_5", self, "rotation_5")
# warning-ignore:return_value_discarded
	get_parent().get_child(6).connect("rotate_6", self, "rotation_6")
# warning-ignore:return_value_discarded
	get_parent().get_child(7).connect("rotate_7", self, "rotation_7")
# warning-ignore:return_value_discarded
	get_parent().get_child(8).connect("rotate_8", self, "rotation_8")

func rotation_1():
	self.rotation_degrees = -45
func rotation_2():
	self.rotation_degrees = 0
func rotation_3():
	self.rotation_degrees = 45
func rotation_4():
	self.rotation_degrees = 90
func rotation_5():
	self.rotation_degrees = 135
func rotation_6():
	self.rotation_degrees = 180
func rotation_7():
	self.rotation_degrees = -135
func rotation_8():
	self.rotation_degrees = -90