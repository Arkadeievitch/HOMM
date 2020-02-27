extends Node2D

# warning-ignore:unused_class_variable
export var SIDE : int
# warning-ignore:unused_class_variable
export var IA  : bool
# warning-ignore:unused_class_variable
export(String, "Heaven", "Sylve", "Academia", "Hell", "Necropolis", "Cave", "Orcs", "Jungle", "Mountains") var FACTION
# warning-ignore:unused_class_variable
export var RANGED : 		bool = false
# warning-ignore:unused_class_variable
export var ARROW : String = "Pick_in_FightmodeEffects"

# warning-ignore:unused_class_variable
export var NAME : 			String
export var MAX_HP : 		int
export var NUMBER : 		int

export var DAMAGE : 		int
export var DISPLACEMENT : 	int
export var INITIATIVE : 	int

var TOTAL_HP : int

var Information_Panel = load("res://Assets/TSCN/UnitInfo_Panel/Information_Panel.tscn")
var MOUSE_BATTLE
var MOUSE_MENU

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
	
	if has_node("/root/MainNode/Battlefield"):
		MOUSE_BATTLE = get_node("/root/MainNode/Battlefield/Mouse_Cursor/Mouse_Front")
	elif has_node("/root/MainNode/SelectionMenu"):
		MOUSE_MENU = get_node("/root/MainNode/SelectionMenu/Mouse_Cursor/Mouse_Front")

# warning-ignore:unused_argument
func _input(event):
	if Input.is_action_just_pressed("ui_rightclic"):
		
		if has_node("/root/MainNode/Battlefield"):
			
			if (abs(MOUSE_BATTLE.global_position.x - self.global_position.x) <= 32
			&& abs(MOUSE_BATTLE.global_position.y - self.global_position.y) <= 32):
				var info_panel = Information_Panel.instance()
				get_node("/root/MainNode/Battlefield").add_child(info_panel, true)
				info_panel.defineUnit(self)
				
				if get_parent().scale.x > 0 :
					info_panel.global_position = Vector2(64, 192)
				else:
					self.scale.x = -1
					info_panel.global_position = Vector2(get_viewport().size.x-256, 192)
					
		elif has_node("/root/MainNode/SelectionMenu"):
			
			if get_child_count()>0:
				for i in get_child_count():
					get_child(i).queue_free()
		
			if (abs(MOUSE_MENU.global_position.x - self.global_position.x) <= 32
			&& abs(MOUSE_MENU.global_position.y - self.global_position.y) <= 32):
				var info_panel = Information_Panel.instance()
				add_child(info_panel, true)
				info_panel.defineUnit(self)
				if self.global_position.x - get_viewport().size.x/2 < 0 :
					info_panel.position = Vector2(56, -64)
				else:
					info_panel.position = Vector2(-248, -64)

func UpdateNumberFromHP():
	NUMBER = int(ceil(float(float(TOTAL_HP)/float(MAX_HP))))

func TakeDamage(Damage_taken):
	TOTAL_HP = int(max(0,TOTAL_HP - Damage_taken))