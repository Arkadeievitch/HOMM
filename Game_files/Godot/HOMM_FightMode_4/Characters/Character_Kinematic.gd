extends KinematicBody2D

class_name Character

export var Side : int

var Priority : float = 0.0
var active_turn : bool = false
var displacement_allowed : bool = false

var STATS : Node
var TWEEN : Node
var TURN : Node
var MOUSE : Node

signal action
signal end_of_action
signal end_of_priority_calculation

var Target_position : Vector2

#_________________________________
func _ready():
	list_other_nodes()
	Priority = float(STATS.INITIATIVE)
	Target_position = self.position
	connect_Turn()

# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_pressed("ui_leftclic"):
		if (active_turn == true && displacement_allowed == true):
			displacement()
			yield(TWEEN,"tween_completed")
			emit_signal("action")
			end_displacement()
			emit_signal("end_of_action")
		elif(active_turn == true 
			&& MOUSE.Tile_target.x - self.position.x < 32 
			&& MOUSE.Tile_target.y - self.position.y < 32):
			emit_signal("action")
			end_displacement()
			emit_signal("end_of_action")
		elif active_turn == false :
			increment_Priority()
			emit_signal("end_of_priority_calculation")
		else:
			print("clicked outside")
	
	displacement_allowed = false

#=========================================
func list_other_nodes():
	STATS = get_node("icon/Stats")
	TWEEN = get_node("Tween")
	MOUSE = get_node("/root/Battlefield/Mouse/Mouse_Cursor")
	TURN = get_parent()
	
func displacement():
	if abs(MOUSE.Tile_offset.x) <= 1:
		Target_position = Vector2(	round(get_global_mouse_position().x/64)*64+32,
									round(get_global_mouse_position().y/64)*64
									+round(MOUSE.Tile_offset.y/32)*32)
	else:
		if abs(MOUSE.Tile_offset.y) <= 1:
			Target_position = Vector2(	round(get_global_mouse_position().x/64)*64
										+round(MOUSE.Tile_offset.x/32)*32,
										round(get_global_mouse_position().y/64)*64-32)
		else:
			Target_position = Vector2(	round(get_global_mouse_position().x/64)*64
										+round(MOUSE.Tile_offset.x/32)*32,
										round(get_global_mouse_position().y/64)*64
										+round(MOUSE.Tile_offset.y/32)*32)
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
	
func increment_Priority():
	Priority += float(STATS.INITIATIVE) / float(get_parent().Char_number)
	
#===SIGNALS FUNCTIONS==================================================
#___CONNECT___
func connect_Turn():
# warning-ignore:return_value_discarded
	TWEEN.connect("tween_completed", self, "onTweenCompletion")
	for i in TURN.get_child_count():
# warning-ignore:return_value_discarded
		TURN.get_child(i).connect("action", self, "Character_attacked")
	
func allowing_movement():
	displacement_allowed = true

func onTweenCompletion(Object_argument, NodePath_Key_argument):
#	print(Object_argument, " ", NodePath_Key_argument)
	pass
	
func Character_attacked():
	if active_turn ==false :
		print(MOUSE.Action_target, " is mouse")
		print(self.global_position, " is ", STATS.NAME)		
	if (active_turn ==false 
	&& abs(MOUSE.Action_target.x - self.global_position.x) <= 32
	&& abs(MOUSE.Action_target.y - self.global_position.y) <= 32):
		print(STATS.NAME, " is attacked")
