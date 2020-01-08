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
	connect_to_characters()
	connect_Turn()

# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_pressed("ui_leftclic"):
		if active_turn == true && displacement_allowed == true:
			displacement()
			yield(TWEEN,"tween_completed")
			emit_signal("action")
			emit_signal("end_of_action")
			end_displacement()
		elif(active_turn == true 
			&& MOUSE.Tile_target.x - self.position.x < 32 
			&& MOUSE.Tile_target.y - self.position.y < 32):
			emit_signal("action")
			emit_signal("end_of_action")
			end_displacement()
		elif active_turn == true :
			print("clicked outside")
		else:
			pass
	
	displacement_allowed = false

#=========================================
func list_other_nodes():
	STATS = get_node("icon/Stats")
	TWEEN = get_node("Tween")
	MOUSE = get_node("/root/Battlefield/Mouse/Mouse_Cursor")
	TURN = get_parent()
	
func displacement():
	
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
	
func connect_to_characters():
	for i in TURN.get_child_count():
		# warning-ignore:return_value_discarded
		TURN.get_child(i).connect("action", self, "Character_attacked")
		# warning-ignore:return_value_discarded
		TURN.get_child(i).connect("end_of_action", self, "increment_priorities")
	

func allowing_movement(Target_tile_position):
	displacement_allowed = true
	Target_position = Target_tile_position

func onTweenCompletion(Object_argument, NodePath_Key_argument):
#	print(Object_argument, " ", NodePath_Key_argument)
	pass
	
func Character_attacked():
	if (active_turn ==false 
	&& abs(MOUSE.Action_target.x - self.global_position.x) <= 32
	&& abs(MOUSE.Action_target.y - self.global_position.y) <= 32):
		print(STATS.NAME, " is attacked")
		print(STATS.NUMBER, " is attacked")
		if STATS.NUMBER == 0:
			self.queue_free()
			
func increment_priorities():
	if active_turn == false :
		increment_Priority()
		emit_signal("end_of_priority_calculation")
