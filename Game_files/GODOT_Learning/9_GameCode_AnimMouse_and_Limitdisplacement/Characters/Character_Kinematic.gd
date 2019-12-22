extends KinematicBody2D

class_name Character

var Priority : float = 0.0
var active_turn : bool = false
var displacement_allowed : bool = false

var STATS : Node
var TWEEN : Node
var TURN : Node
var MOUSE : Node

signal end_of_action
signal end_of_priority_calculation

var Target_position : Vector2

#_________________________________
func _ready():
#	self.position = Vector2(round(self.position.x/64)*64, round(self.position.y/64)*64)
	list_other_nodes()
	Priority = float(STATS.INITIATIVE)
	Target_position = self.position
	TWEEN.connect("tween_completed", self, "On_Tween_completion")

func _process(delta):
#	if TURN.a_tween_is_active == false:
	if Input.is_action_just_pressed("ui_leftclic"):
		if active_turn == true && displacement_allowed == true:
			displacement()
			yield(TWEEN,"tween_completed")
			end_displacement()
			signal_end_of_action()
		else:
			increment_Priority()
			signal_end_of_priority_calculation()
	
	displacement_allowed = false

#=========================================
#___1___
func list_other_nodes():
	STATS = get_node("icon/Stats")
	TWEEN = get_node("Tween")
	MOUSE = get_node("/root/Battlefield/Mouse/Mouse_Cursor")
	TURN = get_parent()
	
func displacement():
	if abs(MOUSE.Active_target.x) <= 1:
		Target_position = Vector2(	round(get_global_mouse_position().x/64)*64+32,
									round(get_global_mouse_position().y/64)*64
									+round(MOUSE.Active_target.y/32)*32)
	else:
		if abs(MOUSE.Active_target.y) <= 1:
			Target_position = Vector2(	round(get_global_mouse_position().x/64)*64
										+round(MOUSE.Active_target.x/32)*32,
										round(get_global_mouse_position().y/64)*64-32)
		else:
			Target_position = Vector2(	round(get_global_mouse_position().x/64)*64
										+round(MOUSE.Active_target.x/32)*32,
										round(get_global_mouse_position().y/64)*64
										+round(MOUSE.Active_target.y/32)*32)
	TWEEN.interpolate_property(self, 
								"position", 
								self.global_position, 
								Target_position, 
								0.5, 
								Tween.TRANS_LINEAR, 
								Tween.EASE_OUT)
	TWEEN.start()

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
func allowing_movement():
	displacement_allowed = true

func On_Tween_completion():
	pass