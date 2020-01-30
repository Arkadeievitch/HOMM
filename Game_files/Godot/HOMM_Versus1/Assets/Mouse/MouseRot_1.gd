extends Position2D

signal rotate_1

var Characters
var Character_number

var TURN

func _ready():
	if has_node("/root/Battlefield") == true:
		TURN = get_node("/root/Battlefield/Turn")
		update_character_arrays()

# warning-ignore:unused_argument
func _process(delta):
	if has_node("/root/Battlefield") == true:
		update_character_arrays()
		for i in range(Character_number) :
			if Characters[i].active_turn == true :
				pass
			else:
				if( 	abs(self.global_position.x-Characters[i].global_position.x) <= 32
					&& 	abs(self.global_position.y-Characters[i].global_position.y) <= 32):
						emit_signal("rotate_1")

func update_character_arrays():
	Characters = TURN.get_children()
	Character_number = TURN.get_child_count()