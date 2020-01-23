extends Node

signal rotateN
signal rotateNW
signal rotateNE
signal rotateS
signal rotateSW
signal rotateSE
signal rotateE
signal rotateW

var rot1 : bool = false
var rot2 : bool = false
var rot3 : bool = false
var rot4 : bool = false
var rot5 : bool = false
var rot6 : bool = false
var rot7 : bool = false
var rot8 : bool = false

func _ready():
	connectNode():	
	
func _process(delta):
	rot1 = false
	rot2 = false
	rot3 = false
	rot4 = false
	rot5 = false
	rot6 = false
	rot7 = false
	rot8 = false

func connectNode():
	get_child(0).get_node("Rotations").get_child(0).connect("rotate_1", self, "rotation_1")
# warning-ignore:return_value_discarded
	get_child(0).get_node("Rotations").get_child(1).connect("rotate_2", self, "rotation_2")
# warning-ignore:return_value_discarded
	get_child(0).get_node("Rotations").get_child(2).connect("rotate_3", self, "rotation_3")
# warning-ignore:return_value_discarded
	get_child(0).get_node("Rotations").get_child(3).connect("rotate_4", self, "rotation_4")
# warning-ignore:return_value_discarded
	get_child(0).get_node("Rotations").get_child(4).connect("rotate_5", self, "rotation_5")
# warning-ignore:return_value_discarded
	get_child(0).get_node("Rotations").get_child(5).connect("rotate_6", self, "rotation_6")
# warning-ignore:return_value_discarded
	get_child(0).get_node("Rotations").get_child(6).connect("rotate_7", self, "rotation_7")
# warning-ignore:return_value_discarded
	get_child(0).get_node("Rotations").get_child(7).connect("rotate_8", self, "rotation_8")

func rotation_1():
	rot1 = true
	emit_signal(rotateN)

func rotation_2():
	rot2 = true
	if rot2 == true && rot1 == true:
		emit_signal(rotateN)
	elif rot2 == true && rot3 == true:
		emit_signal(rotateE)
	else :
		emit_signal(rotateNE)

func rotation_3():
	rot3 = true
	emit_signal(rotateE)
	

func rotation_4():
	rot4 = true
	if rot4 == true && rot3 == true:
		emit_signal(rotateE)
	elif rot4 == true && rot5 == true:
		emit_signal(rotateS)
	else :
		emit_signal(rotateSE)
	

func rotation_5():
	rot5 = true
	emit_signal(rotateS)
	

func rotation_6():
	rot6 = true
	if rot6 == true && rot5 == true:
		emit_signal(rotateS)
	elif rot6 == true && rot7 == true:
		emit_signal(rotateW)
	else :
		emit_signal(rotateSW)
	

func rotation_7():
	rot7 = true
	emit_signal(rotateW)
	

func rotation_8():
	rot8 = true
	if rot8 == true && rot7 == true:
		emit_signal(rotateW)
	elif rot8 == true && rot1 == true:
		emit_signal(rotateN)
	else :
		emit_signal(rotateNW)
	
