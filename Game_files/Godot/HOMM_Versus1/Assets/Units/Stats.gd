extends Node

# warning-ignore:unused_class_variable
export var SIDE : int
enum PLAYER  {Human, AI}
# warning-ignore:unused_class_variable
export(PLAYER) var player
# warning-ignore:unused_class_variable
export var RANGED : 		bool = false

# warning-ignore:unused_class_variable
export var NAME : 			String
export var MAX_HP : 		int
export var NUMBER : 		int

export var DAMAGE : 		int
export var DISPLACEMENT : 	int
export var INITIATIVE : 	int

var TOTAL_HP : int

func _ready():
	TOTAL_HP = NUMBER * MAX_HP
	if MAX_HP == 0:
		print("Dead Character")
	if NUMBER == 0:
		print("Dead Character")
	if DISPLACEMENT == 0:
		print("Character can't move")
	if DAMAGE == 0:
		DAMAGE = 1
	if INITIATIVE == 0:
		INITIATIVE = 1

func UpdateNumberFromHP():
	NUMBER = int(ceil(float(float(TOTAL_HP)/float(MAX_HP))))

func TakeDamage(Damage_taken):
	TOTAL_HP = int(max(0,TOTAL_HP - Damage_taken))