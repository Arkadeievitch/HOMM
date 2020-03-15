extends Node2D

class_name Character

var Priority : float = 0.0
# warning-ignore:unused_class_variable
var active_turn : bool = false # Utilisee par le compteur d'unité et turn
var displacement_allowed : bool = false

var STATS : 	Node
var TWEEN : 	Node
var TURN : 		Node
var MOUSE : 	Node
var TEMPORARY : Node

var Action_position : Vector2
#var Tile_position : Vector2

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

# warning-ignore:unused_argument
func allowing_movement(Target_tile_position): # triggered by target tile
	displacement_allowed = true
	# TargetTile_Position = Target_tile_position

func getNodesfromTree():
	STATS = get_node("icon/Stats")
	TWEEN = get_node("/root/MainNode/Battlefield/Tween")
	MOUSE = get_node("/root/MainNode/Battlefield/Mouse_Cursor")
	TURN = get_parent()
	TEMPORARY = get_node("Temporary")

#=========================================

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

func ANIM_MeleeAttack(Target_position):
	var Fauchage = load(str("res://Assets/TSCN/FightmodeEffects/Fauchage.tscn"))
	Fauchage = Fauchage.instance()
	add_child(Fauchage, true)
	
	if Target_position.x - self.global_position.x < 0:
		get_node("icon").scale.x = -1
	elif Target_position.x - self.global_position.x > 0:
		get_node("icon").scale.x = 1
	
	var rotation_target : float
	if get_node("icon").scale.x < 0:
		Fauchage.scale = Vector2(-2, 2)
		rotation_target = -PI/2
	else:
		Fauchage.scale = Vector2(2, 2)
		rotation_target = PI/2
	
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

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func Nothing(Path_name, Object_name):
	pass