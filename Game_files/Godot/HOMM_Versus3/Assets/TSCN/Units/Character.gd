extends Node2D

class_name Character

var Priority : float = 0.0
var active_turn : bool = false
var displacement_allowed : bool = false

var STATS : 	Node
var TWEEN : 	Node
var TURN : 		Node
var MOUSE : 	Node
var TEMPORARY : Node

var Action_position : Vector2
var Tile_position : Vector2

func _ready():
	getNodesfromTree()
	Priority = float(STATS.INITIATIVE)
	Action_position = self.position
	self.z_as_relative = false
	self.z_index = 5

# warning-ignore:unused_argument
func _process(delta):
	if STATS.IA == false:
		displacement_allowed = false

func getNodesfromTree():
	STATS = get_node("icon/Stats")
	TWEEN = get_node("Tween")
	MOUSE = get_node("/root/MainNode/Battlefield/Mouse_Cursor")
	TURN = get_parent()
	TEMPORARY = get_node("Temporary")

#=========================================
func _PassiveAction(Mouse_action):
	if active_turn == false:
		Character_attacked(Mouse_action)
		incrementPriorities()

#=========================================
# warning-ignore:unused_argument
func _PlayAction(Mouse_tile, Mouse_Action):

	if STATS.IA == true: # si IA (pas de Target_tile)
		displacement_allowed = true
		
	var SelfPosition = self.global_position
	if(active_turn == true
	&& abs(Mouse_tile.x - SelfPosition.x) <= 32 
	&& abs(Mouse_tile.y - SelfPosition.y) <= 32): # Cas où l'unité attaque ou CaC
		get_parent().ActiveCharacterPlayed = true
		ANIM_MeleeAttack()
	elif (active_turn == true 
		&& displacement_allowed == true): # Cas où l'unité se déplace.
		if STATS.IA == false: # si IA (pas de Target_tile)
			Mouse_tile = Tile_position
		get_parent().CharacterIsMoving = true
		ANIM_displacement(Mouse_tile)
		get_node("icon").onAction(Mouse_Action, Mouse_tile)
		ANIM_MeleeAttack()
		get_parent().ActiveCharacterPlayed = true
	elif STATS.RANGED == true && active_turn == true : # Cas d'attaque à distance
		get_parent().ActiveCharacterPlayed = true
		ANIM_rangedAttack(Mouse_Action)
	elif active_turn == true :
		print("clicked outside")
	else:
		pass
#=========================================

func ANIM_displacement(displacement_Tile):
	TWEEN.interpolate_property(self, 
								"position", 
								self.global_position, 
								displacement_Tile, 
								0.5, 
								Tween.TRANS_LINEAR, 
								Tween.EASE_OUT)
	TWEEN.start()

func ANIM_rangedAttack(Target):
	
	var arrow = load(str("res://Assets/TSCN/FightmodeEffects/", STATS.ARROW, ".tscn"))
	arrow = arrow.instance()
	add_child(arrow, true)
	
	if self.global_position.x - Target.x < 0:
		arrow.scale.x = 1
	else:
		arrow.scale.x = -1
	
	var TWEEN_ARROW = arrow.get_node("Tween_Arrow")
	# warning-ignore:return_value_discarded
	TWEEN_ARROW.connect("user_tween_completed", self, "removeArrow")
	TWEEN_ARROW.interpolate_property(arrow, 
								"global_position", 
								self.global_position, 
								Target, 
								0.4, 
								Tween.TRANS_LINEAR, 
								Tween.EASE_OUT)
	TWEEN_ARROW.start()

func removeArrow(ObjectArrow):
	ObjectArrow.queue_free()

func ANIM_MeleeAttack():
	
	var Fauchage = load(str("res://Assets/TSCN/FightmodeEffects/Fauchage.tscn"))
	Fauchage = Fauchage.instance()
	add_child(Fauchage, true)
	
	var rotation_target : float
	if self.scale.x < 0:
		Fauchage.scale.x = -2
		rotation_target = -PI/4
	else:
		Fauchage.scale.x = 2
		rotation_target = PI/4
	
	var TWEEN_REAP = Fauchage.get_node("Tween_Fauchage")
	# warning-ignore:return_value_discarded
	TWEEN_REAP.connect("user_tween_completed", self, "removeArrow")
	TWEEN_REAP.interpolate_property(Fauchage, 
								"rotation", 
								self.rotation, 
								rotation_target, 
								0.4, 
								Tween.TRANS_LINEAR, 
								Tween.EASE_OUT)
	TWEEN_REAP.start()

func endAction():
		Priority = 0.0
		active_turn = false
		if has_node("Active_Border"):
			get_node("Active_Border").queue_free()
	
func calculate_Priority():
	Priority += float(STATS.INITIATIVE) / float(get_parent().Character_number)
	
func allowing_movement(Target_tile_position): # triggered by child target tile
	displacement_allowed = true
	Tile_position = Target_tile_position

func incrementPriorities():
	if active_turn == false :
		calculate_Priority()
	
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func Nothing(Path_name, Object_name):
	pass
	
# warning-ignore:unused_argument
func Character_attacked(Attacked_Action_position):
	var Damage_taken : int = 0
	var ATTACKER
	if Attacked_Action_position != null:
		if (active_turn == false 
		&& abs(Attacked_Action_position.x - self.global_position.x) <= 32
		&& abs(Attacked_Action_position.y - self.global_position.y) <= 32):
			
			for i in TURN.get_child_count():
				if TURN.get_child(i).active_turn == true:
					ATTACKER = TURN.get_child(i).get_node("icon/Stats")
					
			if ATTACKER.SIDE != STATS.SIDE :
				print(STATS.NAME, " is attacked by ", ATTACKER.NAME)
				Damage_taken = ATTACKER.DAMAGE * ATTACKER.NUMBER
				
				STATS.TakeDamage(Damage_taken)
				STATS.UpdateNumberFromHP()
				
				if STATS.NUMBER > 1:
					print(STATS.NUMBER, " members left in ", STATS.NAME, " unit")
				else:
					print(STATS.NUMBER, " ", STATS.NAME, " left")