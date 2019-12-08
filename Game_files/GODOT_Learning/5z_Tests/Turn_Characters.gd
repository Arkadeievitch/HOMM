extends Node

var Highest_priority : float = 0.0
var Char_number : int = 0
var Priorities = []
var Char_to_activate : int = 0

var i : int = 0

var Turn_wait_for_end_of_action : bool = false

signal Priorities_calculated

#______________________________________
func _ready():
	print("Turn_Character/ ready()")
	self.connect("Priorities_calculated", self, "_input")
		
	activate_player_with_priority()
	
	

#______________________________________
func _input(event):
	if Input.is_action_just_pressed("ui_leftclic") :
		print("Turn_Character/ input(event)/leftclic")
		activate_player_with_priority()


#______________________________________
func activate_player_with_priority():
	
	print("Priority signal emission")
	emit_signal("Priorities_calculated")
	print("Priority signal emitted")
	print("_")
