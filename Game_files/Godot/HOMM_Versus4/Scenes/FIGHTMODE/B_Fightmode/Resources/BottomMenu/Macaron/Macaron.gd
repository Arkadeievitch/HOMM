extends Sprite

var MOUSE_FRONT : Node
var MOUSE_REAR : Node
var MOUSE : Node
var TURN : Node
var TargetTileGenerated : bool = false

var Macaron_occupe_melee : bool = false
var Macaron_occupe_range : bool = false
var Macaron_occupe_magic : bool = false

var Ranged_playing : bool = false

var MAC_MELEE : Node
var MAC_RANGE : Node
var MAC_MAGIC : Node
var MAC_LABEL : Node
var MAC_LABEL_COUNTER : Node

var MAC_MELEE_FOND : Node
var MAC_RANGE_FOND : Node
var MAC_MAGIC_FOND : Node

func _ready():
	if has_node("/root/MainNode/Battlefield"):
		MOUSE = get_node("/root/MainNode/Battlefield/Mouse_Cursor")
		MOUSE_FRONT = get_node("/root/MainNode/Battlefield/Mouse_Cursor/Mouse_Front")
		MOUSE_REAR = get_node("/root/MainNode/Battlefield/Mouse_Cursor/Mouse_Rear")
		TURN = get_node("/root/MainNode/Battlefield/Turn")
		
		MAC_MELEE_FOND = get_node("MacaronFond_Melee")
		MAC_RANGE_FOND = get_node("MacaronFond_Distance")
		MAC_MAGIC_FOND = get_node("MacaronFond_Magie")
		MAC_MELEE = get_node("MacaronFond_Melee/Macaron_Melee")
		MAC_RANGE = get_node("MacaronFond_Distance/Macaron_Distance")
		MAC_MAGIC = get_node("MacaronFond_Magie/Macaron_Magie")
		
		MAC_LABEL = get_node("Mac_Label")
		MAC_LABEL_COUNTER = get_node("Mac_LabelCounter")
		MAC_LABEL.text = ""
		MAC_LABEL_COUNTER.text = ""

# warning-ignore:unused_argument
func _process(delta):
	if MOUSE.Mouse_Inhibition == false: # Doit permettre d'éviter l'exécution en cas de mort
		if (MOUSE_FRONT.found_target==true # Prévision dégâts au CAC.
		&& ((abs(TURN.CHARACTERS[TURN.ActiveCharacter_index].global_position.x
		-MOUSE_REAR.global_position.x) < 32
		&& abs(TURN.CHARACTERS[TURN.ActiveCharacter_index].global_position.y
		-MOUSE_REAR.global_position.y) < 32)
		|| TargetTileGenerated == true)):
			if MAC_MELEE.position == Vector2(0,0):
				Macaron_occupe_melee = true
				MAC_MELEE.get_node("AnimPlayer_MacMelee").play("Activation")
				
				var Damages = TURN.DAMAGE[TURN.ActiveCharacter_index]*TURN.NUMBER[TURN.ActiveCharacter_index]
				var HP_MAX = TURN.MAX_HP[MOUSE_FRONT.Target_index]
				var HP_TOT = TURN.TOTAL_HP[MOUSE_FRONT.Target_index]
				var DEF_NUMBER = TURN.NUMBER[MOUSE_FRONT.Target_index]
				
				var TOTAL_HP_left = int(max(0,HP_TOT - Damages))
				var NUMBER_left = int(ceil(float(float(TOTAL_HP_left)/float(HP_MAX))))
				var KILLS = DEF_NUMBER - NUMBER_left
				
				MAC_LABEL.text = str(KILLS, " kills")
				
				if (TURN.COUNTERSTRIKE_READY[MOUSE_FRONT.Target_index] == true
				&& TURN.COUNTERSTRIKE_ALLOWED[MOUSE_FRONT.Target_index] == true):
					MAC_LABEL_COUNTER.text = "Counterstrike"
				else: 
					MAC_LABEL_COUNTER.text = ""
		else:
			if MAC_MELEE.position.y <= -150:
				MAC_LABEL_COUNTER.text = ""
				MAC_LABEL.text = ""
				MAC_MELEE.get_node("AnimPlayer_MacMelee").play_backwards("Activation",-4)
				Macaron_occupe_melee = false
		
		if (MOUSE_FRONT.found_target==true # Prévision dégâts à distance.
			&& Ranged_playing == true 
			&& Macaron_occupe_melee ==false
			&& Macaron_occupe_magic == false):
			if MAC_RANGE.position == Vector2(0,0):
				Macaron_occupe_range = true
				MAC_RANGE.get_node("AnimPlayer_MacRange").play("Activation")
				
				var Damages = TURN.DAMAGE[TURN.ActiveCharacter_index]*TURN.NUMBER[TURN.ActiveCharacter_index]
				var HP_MAX = TURN.MAX_HP[MOUSE_FRONT.Target_index]
				var HP_TOT = TURN.TOTAL_HP[MOUSE_FRONT.Target_index]
				var DEF_NUMBER = TURN.NUMBER[MOUSE_FRONT.Target_index]
				
				var TOTAL_HP_left = int(max(0,HP_TOT - Damages))
				var NUMBER_left = int(ceil(float(float(TOTAL_HP_left)/float(HP_MAX))))
				var KILLS = DEF_NUMBER - NUMBER_left
				
				MAC_LABEL.text = str(KILLS, " kills")
				MAC_LABEL_COUNTER.text = ""
		else:
			if MAC_RANGE.position.x == 128:
				MAC_LABEL.text = ""
				MAC_LABEL_COUNTER.text = ""
				MAC_RANGE.get_node("AnimPlayer_MacRange").play_backwards("Activation",-4)
				Macaron_occupe_range = false
		
		TargetTileGenerated = false

# warning-ignore:unused_argument
func Target_Tile(Position):
	TargetTileGenerated = true
