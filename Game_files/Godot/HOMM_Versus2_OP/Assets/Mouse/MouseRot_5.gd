extends Position2D

signal rotate_5

var Characters
var Character_number

var active_character = 100

var TURN

func _ready():
	if has_node("/root/MainNode/Battlefield") == true:
		TURN = get_node("/root/MainNode/Battlefield/Turn")
		update_character_arrays()
	
# warning-ignore:unused_argument
func _process(delta):
	if has_node("/root/MainNode/Battlefield") == true:
		update_character_arrays()
		for i in range(Character_number) :
			if Characters[i].active_turn == true :
				active_character = i
				pass
			else:
				if( 	abs(self.global_position.x-Characters[i].global_position.x) <= 31
					&& 	abs(self.global_position.y-Characters[i].global_position.y) <= 31):
					if active_character < 100:
						if (Characters[i].get_node("icon/Stats").SIDE == 
							Characters[active_character].get_node("icon/Stats").SIDE):
							pass
						else:
							emit_signal("rotate_5")
					else:
						emit_signal("rotate_5")

func update_character_arrays():
	Characters = TURN.get_children()
	Character_number = TURN.get_child_count()