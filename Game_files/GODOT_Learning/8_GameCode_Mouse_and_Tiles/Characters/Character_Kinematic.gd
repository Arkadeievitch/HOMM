extends KinematicBody2D

var Priority : float = 0.0
var active_turn : bool = false

var STATS : Node
var TWEEN : Node
var TURN : Node

signal end_of_action
signal end_of_priority_calculation

var Target_position : Vector2

#_________________________________
func _ready():
	STATS = get_node("icon/Stats")
	TWEEN = get_node("Tween")
	TURN = get_parent()
	Priority = float(STATS.INITIATIVE)
	Target_position = self.position

func _process(delta):
#	if TURN.a_tween_is_active == false:
	if Input.is_action_just_pressed("ui_leftclic"):
		if active_turn == true:
			Target_position = get_global_mouse_position()
			TWEEN.interpolate_property(self, 
										"position", 
										self.global_position, 
										Target_position, 
										0.5, 
										Tween.TRANS_LINEAR, 
										Tween.EASE_OUT)
			TWEEN.start()
			
			end_displacement()
			signal_end_of_action()
		else:
			increment_Priority()
			signal_end_of_priority_calculation()

#=========================================
#___1___
func end_displacement():
		Priority = 0.0
		active_turn = false
#___2___
func signal_end_of_action():
#	print("SIGNAL : End of Action")
	emit_signal("end_of_action")
#___3___
func signal_end_of_priority_calculation():
#	print("SIGNAL : End of Priority calculation")
	emit_signal("end_of_priority_calculation")
#___4___
func increment_Priority():
	Priority += float(STATS.INITIATIVE) / float(get_parent().Char_number)
	
#===SIGNALS FUNCTIONS==================================================
#___CONNECT___
	
	