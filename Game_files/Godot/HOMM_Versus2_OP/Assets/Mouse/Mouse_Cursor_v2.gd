extends Node2D

var TURN : Node
var TileTarget : Vector2
var ActionTarget : Vector2

var character_position : Vector2

func _ready():
	if has_node("/root/MainNode/Battlefield"):
		TURN = get_node("/root/MainNode/Battlefield/Turn")

# warning-ignore:unused_argument
func _process(delta):
	self.global_position = get_global_mouse_position()
	
	if has_node("/root/MainNode/Battlefield"):
		for i in TURN.get_child_count():
			character_position = TURN.get_child(i).global_position
			if (character_position.x - self.global_position.x 	< 18+32
			&& character_position.x - self.global_position.x 	> 0
			&& character_position.y - self.global_position.y 	> -(18+32)
			&& character_position.y - self.global_position.y 	< 0):
				self.rotation_degrees = 0
			elif (character_position.x - self.global_position.x < 18+32
			&& character_position.x - self.global_position.x 	> 0
			&& character_position.y - self.global_position.y 	< 18+32
			&& character_position.y - self.global_position.y 	> 0):
				self.rotation_degrees = 90
			elif (character_position.x - self.global_position.x > -(18+32)
			&& character_position.x - self.global_position.x 	< 0
			&& character_position.y - self.global_position.y 	< 18+32
			&& character_position.y - self.global_position.y 	> 0):
				self.rotation_degrees = 180
			elif (character_position.x - self.global_position.x > -(18+32)
			&& character_position.x - self.global_position.x 	< 0
			&& character_position.y - self.global_position.y 	> -(18+32)
			&& character_position.y - self.global_position.y 	< 0):
				self.rotation_degrees = -90
			
			# rotations à l'horizontale/verticale
			elif (character_position.x - self.global_position.x < 30+32
			&& character_position.x - self.global_position.x 	> 0
			&& abs(character_position.y - self.global_position.y) < 4):
				self.rotation_degrees = 45
			elif (abs(character_position.x - self.global_position.x) < 4
			&& character_position.y - self.global_position.y 	< 30+32
			&& character_position.y - self.global_position.y 	> 0):
				self.rotation_degrees = 135
			elif (character_position.x - self.global_position.x > -(30+32)
			&& character_position.x - self.global_position.x 	< 0
			&& abs(character_position.y - self.global_position.y) < 4):
				self.rotation_degrees = -135
			elif (abs(character_position.x - self.global_position.x) < 4
			&& character_position.y - self.global_position.y 	> -(30+32)
			&& character_position.y - self.global_position.y 	< 0):
				self.rotation_degrees = -45
			else:
				self.rotation_degrees = 0
				
	else:
		self.rotation_degrees = 0