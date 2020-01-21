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

#signal action
#signal endAction
#signal end_of_calculation

var Action_position : Vector2
var Tile_position : Vector2

func _ready():
	getNodesfromTree()
	Priority = float(STATS.INITIATIVE)
	Action_position = self.position

# warning-ignore:unused_argument
func _process(delta):
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

func endAction():
		Priority = 0.0
		active_turn = false
	
func calculate_Priority():
	Priority += float(STATS.INITIATIVE) / float(get_parent().Character_number)
	
func allowing_movement(Target_tile_position): # triggered by child target tile
	displacement_allowed = true
	Tile_position = Target_tile_position

func _PassiveAction(action, tile):
	if active_turn == false:
		Character_attacked(action, tile)
		incrementPriorities()

# warning-ignore:unused_argument
func _PlayAction(action, tile):
	Action_position = action
	
	var SelfPosition = self.global_position
	if(active_turn == true
		&& abs(tile.x - SelfPosition.x) <= 32 
		&& abs(tile.y - SelfPosition.y) <= 32):
		get_parent().ActiveCharacterPlayed = true
	elif (	active_turn == true 
		&& 	displacement_allowed == true):
		get_parent().CharacterIsMoving = true			
		displacement()
		get_parent().ActiveCharacterPlayed = true
	elif active_turn == true :
		print("clicked outside")
	else:
		pass

func incrementPriorities():
	if active_turn == false :
		calculate_Priority()
	
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func Nothing(Path_name, Object_name):
	pass
	
# warning-ignore:unused_argument
func Character_attacked(Action_position, Tile_position):
	var Damage_taken : int = 0
	var ATTACKER
	
	if (active_turn == false 
	&& abs(Action_position.x - self.global_position.x) <= 32
	&& abs(Action_position.y - self.global_position.y) <= 32):
		
		for i in TURN.get_child_count():
			if TURN.get_child(i).active_turn == true:
				ATTACKER = TURN.get_child(i).get_node("icon/Stats")
				
		if ATTACKER.SIDE != STATS.SIDE :
			print(STATS.NAME, " is attacked")
			Damage_taken = ATTACKER.DAMAGE * ATTACKER.NUMBER
			
			STATS.TakeDamage(Damage_taken)
			STATS.UpdateNumberFromHP()
			
			if STATS.NUMBER > 1:
				print(STATS.NUMBER, " members left in ", STATS.NAME, " unit")
			else:
				print(STATS.NUMBER, " ", STATS.NAME, " left")
				