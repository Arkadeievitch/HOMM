extends Node2D

var i : int = 0

#func _init():

func _ready():
	$icon.connect("is_sent", self, "_on_signal_call")
	get_child(1).get_child(0).connect("is_sent_by_instance", self, "_on_signal_instance_call")
	
	
func _on_signal_call():
	print("signal received ", i)
		
		
func _on_signal_instance_call():
	print("instance signal received ", i)