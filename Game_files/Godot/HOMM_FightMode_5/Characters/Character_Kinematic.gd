extends KinematicBody2D

class_name Character

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
signal dead_character

var Target_position : Vector2

func _ready():
	getNodesfromTree()
	ConnectSelf()
	Priority = float(STATS.INITIATIVE)
	Target_position = self.position

# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_pressed("ui_leftclic"):
		if active_turn == true && displacement_allowed == true:
			displacement()
			yield(TWEEN,"tween_completed")
			print("Signal ", STATS.NAME," : action")
			emit_signal("action")
			print("Signal  ", STATS.NAME,"  : end of action")
			emit_signal("end_of_action")
			end_displacement()
		elif(active_turn == true 
			&& MOUSE.Tile_target.x - self.position.x < 32 
			&& MOUSE.Tile_target.y - self.position.y < 32):
			print("Signal  ", STATS.NAME,"  : action")
			emit_signal("action")
			print("Signal  ", STATS.NAME,"  : end of action")
			emit_signal("end_of_action")
			end_displacement()
		elif active_turn == true :
			print("clicked outside")
		else:
			pass

	displacement_allowed = false

#=========================================
func getNodesfromTree():
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
	
func calculate_Priority():
	Priority += float(STATS.INITIATIVE) / float(get_parent().Char_number)
	
func allowing_movement(Target_tile_position): # triggered by child target tile
	displacement_allowed = true
	Target_position = Target_tile_position
	
#===SIGNALS FUNCTIONS==================================================
#___CONNECT___
func ConnectSelf():
	# warning-ignore:return_value_discarded
	TWEEN.connect("tween_completed", self, "onTweenCompletion")
	# warning-ignore:return_value_discarded
	MOUSE.connect("mouse_clic", self, "Character_attacked")
	# Se connecte aux autres personnages
	for i in TURN.get_child_count():
		# warning-ignore:return_value_discarded
#		TURN.get_child(i).connect("action", self, "Character_attacked")
		# warning-ignore:return_value_discarded
		TURN.get_child(i).connect("end_of_action", self, "increment_priorities")

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func onTweenCompletion(Object_argument, NodePath_Key_argument):
#	print(Object_argument, " ", NodePath_Key_argument)
	pass

func Character_attacked(Target_position):
	var Damage_taken : int = 0
	var ATTACKER
	
	if (active_turn == false 
	&& abs(Target_position.x - self.global_position.x) <= 32
	&& abs(Target_position.y - self.global_position.y) <= 32):
		print(STATS.NAME, " is attacked")
		for i in TURN.get_child_count():
			if TURN.get_child(i).active_turn == true:
				ATTACKER = TURN.get_child(i).get_node("icon/Stats")
				Damage_taken = ATTACKER.DAMAGE * ATTACKER.NUMBER
		
		STATS.TakeDamage(Damage_taken)
		STATS.UpdateNumberFromHP()
		
		if STATS.NUMBER > 1:
			print(STATS.NUMBER, " members left in ", STATS.NAME, " unit")
		else:
			print(STATS.NUMBER, " ", STATS.NAME, " left")
			
		if STATS.NUMBER == 0:
			print(STATS.NAME, " is dead")
			self.queue_free()
			emit_signal("dead_character")
			
#func Character_attacked():
#	var Damage_taken : int = 0
#	var ATTACKER
#
#	print(STATS.NAME, " position: ", self.global_position)
#	print("Mouse target position: ", MOUSE.Action_target, " for ", STATS.NAME)
#
#	if (active_turn == false 
#	&& abs(MOUSE.Action_target.x - self.global_position.x) <= 32
#	&& abs(MOUSE.Action_target.y - self.global_position.y) <= 32):
#		print(STATS.NAME, " is attacked")
#		for i in TURN.get_child_count():
#			if TURN.get_child(i).active_turn == true:
#				ATTACKER = TURN.get_child(i).get_node("icon/Stats")
#				Damage_taken = ATTACKER.DAMAGE * ATTACKER.NUMBER
#
#		STATS.TakeDamage(Damage_taken)
#		STATS.UpdateNumberFromHP()
#
#		if STATS.NUMBER > 1:
#			print(STATS.NUMBER, " members left in ", STATS.NAME, " unit")
#		else:
#			print(STATS.NUMBER, " ", STATS.NAME, " left")
#
#		if STATS.NUMBER == 0:
#			print(STATS.NAME, " is dead")
#			self.queue_free()
#			emit_signal("dead_character")
	
func increment_priorities():
	print(STATS.NAME," try to play")
	if active_turn == false :
		calculate_Priority()
		emit_signal("end_of_priority_calculation")