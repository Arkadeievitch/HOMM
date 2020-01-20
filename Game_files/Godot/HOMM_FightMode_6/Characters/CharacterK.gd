extends KinematicBody2D

class_name Character

var Priority : float = 0.0
var active_turn : bool = false
var displacement_allowed : bool = false

var STATS : Node
var TWEEN : Node
var TURN : Node
var MOUSE : Node
var TEMPORARY : Node

signal action
signal end_of_action
signal end_of_calculation
signal dead_character

var Action_position : Vector2
var Tile_position : Vector2
var Mouse_Tile_position : Vector2

func _ready():
	getNodesfromTree()
	ConnectSelf()
	Priority = float(STATS.INITIATIVE)
	Action_position = self.position

# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_pressed("ui_leftclic"):
		yield(MOUSE,"mouse_clic")
		if active_turn == true && displacement_allowed == true:
			displacement()
			yield(TWEEN,"tween_completed")

	displacement_allowed = false

#=========================================
func getNodesfromTree():
	STATS = get_node("icon/Stats")
	TWEEN = get_node("Tween")
	MOUSE = get_node("/root/Battlefield/Mouse/Mouse_Cursor")
	TURN = get_parent()
	TEMPORARY = get_node("Temporary")
	
func displacement():
	TWEEN.interpolate_property(self, 
								"position", 
								self.global_position, 
								Tile_position, 
								0.5, 
								Tween.TRANS_LINEAR, 
								Tween.EASE_OUT)
	TWEEN.start()

func end_Displacement():
		Priority = 0.0
		active_turn = false
	
func calculate_Priority():
	Priority += float(STATS.INITIATIVE) / float(get_parent().Char_number)
	
func allowing_movement(Target_tile_position): # triggered by child target tile
	displacement_allowed = true
	Tile_position = Target_tile_position
	
#===SIGNALS FUNCTIONS==================================================
#___CONNECT___
func ConnectSelf():
	# warning-ignore:return_value_discarded
	TWEEN.connect("tween_completed", self, "onTweenCompletion")
	# warning-ignore:return_value_discarded
	TEMPORARY.connect("Tiles_deleted", self, "saveMousePositions")
	# Se connecte aux autres personnages
	for i in TURN.get_child_count():
		# warning-ignore:return_value_discarded
		TURN.get_child(i).connect("end_of_action", self, "increment_priorities")
		# warning-ignore:return_value_discarded
		TURN.get_child(i).connect("action", self, "Character_attacked")

# ENVOI SANS MOUVEMENT?
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func onTweenCompletion(Object_argument, NodePath_Key_argument):
	if active_turn == true && displacement_allowed == true:
		emit_signal("action", Action_position, Tile_position)
		# Attaque la cible => calcul des dégâts.
		# Supprime la cible si elle meurt.
		emit_signal("end_of_action")
		# Si inactif : incrémente les priorités.
		# Si actif : fin de déplacement.
		emit_signal("end_of_calculation")
		# TURN : au bout N signaux, 
			# Mets à jour les priorités et active le personnage prioritaire.
			# Signal Priorities_retrieved
	elif(active_turn == true 
		&& abs(Mouse_Tile_position.x - self.global_position.x) <= 32 
		&& abs(Mouse_Tile_position.y - self.global_position.y) <= 32):
		emit_signal("action", Action_position, Tile_position)
		# Attaque la cible => calcul des dégâts.
		# Supprime la cible si elle meurt.
		emit_signal("end_of_action")
		# Si inactif : incrémente les priorités.
		# Si actif : fin de déplacement.
		emit_signal("end_of_calculation")
		# TURN : au bout N signaux, 
			# Mets à jour les priorités et active le personnage prioritaire.
			# Signal Priorities_retrieved
	elif active_turn == true :
		print("clicked outside")
	else:
		pass

func saveMousePositions(action, tile):
	Action_position = action
	Mouse_Tile_position = tile
	
func increment_priorities():
	if active_turn == false :
		calculate_Priority()
	else:
		end_Displacement()
	emit_signal("end_of_calculation")
	
# warning-ignore:unused_argument
func Character_attacked(Action_position, Tile_position):
	var Damage_taken : int = 0
	var ATTACKER
	
	for i in TURN.get_child_count():
		if TURN.get_child(i).active_turn == true:
			ATTACKER = TURN.get_child(i).get_node("icon/Stats")
				
	if (active_turn == false && ATTACKER.SIDE != STATS.SIDE 
	&& abs(Action_position.x - self.global_position.x) <= 32
	&& abs(Action_position.y - self.global_position.y) <= 32):
		print(STATS.NAME, " is attacked")
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