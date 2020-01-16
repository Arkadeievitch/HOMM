extends Node2D

var Active_target : Vector2

func _ready():
	connect_to_rotations()

func _process(delta):
	self.position = Vector2(get_global_mouse_position().x, 
							get_global_mouse_position().y)
	Active_target = Vector2(24, -24)

func connect_to_rotations():
	get_child(1).connect("rotate_1", self, "rotation_1")
	get_child(2).connect("rotate_2", self, "rotation_2")
	get_child(3).connect("rotate_3", self, "rotation_3")
	get_child(4).connect("rotate_4", self, "rotation_4")
	get_child(5).connect("rotate_5", self, "rotation_5")
	get_child(6).connect("rotate_6", self, "rotation_6")
	get_child(7).connect("rotate_7", self, "rotation_7")
	get_child(8).connect("rotate_8", self, "rotation_8")
	
func rotation_1():
	Active_target = Vector2(0, 32)
func rotation_2():
	Active_target = Vector2(-24, 24)
func rotation_3():
	Active_target = Vector2(-32, 0)
func rotation_4():
	Active_target = Vector2(-24, -24)
func rotation_5():
	Active_target = Vector2(0, -32)
func rotation_6():
	Active_target = Vector2(24, -24)
func rotation_7():
	Active_target = Vector2(32, 0)
func rotation_8():
	Active_target = Vector2(24, 24)