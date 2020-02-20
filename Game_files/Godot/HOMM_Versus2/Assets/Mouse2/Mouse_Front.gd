extends Sprite

var TURN : Node
var Character_number : int
var Current_Side : int

func _ready():
	if has_node("/root/MainNode/Battlefield/Turn"):
		TURN = get_node("/root/MainNode/Battlefield/Turn")
		Character_number = TURN.get_child_count()

# Actualise le camp en cours
# warning-ignore:unused_argument
func _input(event):
	if Input.is_action_just_pressed("ui_leftclic"):
		Character_number = TURN.get_child_count()
		for i in Character_number:
			if TURN.get_child(i).active_turn == true:
				Current_Side = TURN.get_child(i).get_node("icon/Stats").SIDE

# Déclenche l'animation et la rotation du curseur s'il pointe un adversaire
# warning-ignore:unused_argument
func _process(delta):
	for i in Character_number:
		var Character = TURN.get_child(i)
		if Character != null:
			if (abs(self.global_position.x - Character.global_position.x) < 32
			&& abs(self.global_position.y - Character.global_position.y) < 32):
				if Character.get_node("icon/Stats").SIDE != Current_Side:
					get_parent().Rotation_Pointeur(Character.global_position)
		else:
			get_parent().rotation = 0