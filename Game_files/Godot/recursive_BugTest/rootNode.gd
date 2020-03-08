extends Node

var global_var1

func _ready():
	global_var1 = [5,3,3.2,6,0]
	
	var childNode = get_node("Chld_Node")
	childNode.updateChronology(global_var1)
	
	print("global_var1 should be = 0.")
	print("global_var1 = ", global_var1)