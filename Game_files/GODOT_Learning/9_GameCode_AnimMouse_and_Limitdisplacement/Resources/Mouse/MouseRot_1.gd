extends Position2D

signal rotate_1

var Characters
var Character_number

func _ready():
	Characters = get_node("/root/Battlefield/Turn").get_children()
	Character_number = get_node("/root/Battlefield/Turn").Char_number
	
func _process(delta):
	for i in range(Character_number) :
		if Characters[i].active_turn == false :
			if 		abs(self.global_position.x-Characters[i].global_position.x) < 30:
				if 	abs(self.global_position.y-Characters[i].global_position.y) < 30:
					emit_signal("rotate_1")