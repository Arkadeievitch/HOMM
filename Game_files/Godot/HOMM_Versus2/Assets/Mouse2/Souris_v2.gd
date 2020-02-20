
# Dans F (front)_________________________________________
var TURN : Node
var Character_number : int
var Current_Side : int

func _ready():
	TURN = get_node("/root/MainNode/Battledield/Turn")
	Character_number = TURN.get_child_count()

# Actualise le camp en cours
func _input(event):
	if Input.is_just_pressed("ui_leftclic"):
		for i in Character_number:
			if TURN.get_child(i).active_turn == true:
				Current_Side = TURN.get_child(i).get_node("icon/Stats").SIDE

# Déclenche l'animation et la rotation du curseur s'il pointe un adversaire
func _process(delta):
	for i in Character_number:
		var Character = TURN.get_child(i)
		if (abs(self.global_position.x - Character.global_position.x) < 32
		&& abs(self.global_position.y - Character.global_position.y) < 32):
			if Character.get_node("icon/Stats").SIDE != Current_Side:
				get_parent().Rotation_Pointeur(Character.global_position)

# Dans Pointeur (avec Front et Rear fixes)____________
var rotating : bool = false

# Cette variable est lue par les tuiles temporaires pour générer la 
# tuile active  à l'avant ou l'arrière du curseur selon l'objet pointé.
func _process(delta):
	if abs(self.rotation) < 0.01:
		rotating = false
	else:
		rotating = true

func Rotation_Pointeur(Character_position):
	
	var deltax : float = float(self.global_position.x)-float(Character_position.x)
	var deltay : float = float(self.global_position.y)-float(Character_position.y)
	var Phi : float = atan(deltay/deltax)
	print("Phi = ", Phi)
	
	var Theta : float  = PI/4 + Phi
	print("Theta = ", Theta)
	
	self.rotation = Theta

# Dans Tiles _________________________________________
extends Node2D

onready var Target_Tile = load("res://Scenes/FIGHTMODE/B_Fightmode/Resources/Temporary_Tiles/Target_Tile.tscn")
var MOUSE

func _ready():
	MOUSE = get_node("/root/MainNode/Battlefield/Mouse")
	
# Génère la tuile cible si le joueur parent est actif.
# - Sur la position avant de la souris si elle est fixe (tuile ciblée).
# - Sur la position arrière de la souris si elle est en rotation (ennemi ciblé).
# warning-ignore:unused_argument
func _physics_process(delta):
	if get_parent().get_parent().active_turn == true:
		if MOUSE.rotating == false:
			if abs(MOUSE.get_node("Mouse_Front").global_position.x + self.global_position.x) <= 32
			&& abs(MOUSE.get_node("Mouse_Front").global_position.y + self.global_position.y) <= 32:
					if get_child_count()==0:
						var add_child = Target_Tile.instance()
						add_child(add_child, true)
				else:
					if get_child_count()>0:
						get_child(0).queue_free()
			else:
				if get_child_count()>0:
					get_child(0).queue_free()
		else:
			if abs(MOUSE.get_node("Mouse_Rear").global_position.x + self.global_position.x) <= 32
			&& abs(MOUSE.get_node("Mouse_Rear").global_position.y + self.global_position.y) <= 32:
					if get_child_count()==0:
						var add_child = Target_Tile.instance()
						add_child(add_child, true)
				else:
					if get_child_count()>0:
						get_child(0).queue_free()
			else:
				if get_child_count()>0:
					get_child(0).queue_free()
			
