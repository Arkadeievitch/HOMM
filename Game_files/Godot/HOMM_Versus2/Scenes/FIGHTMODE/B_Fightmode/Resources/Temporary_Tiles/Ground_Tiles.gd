extends Node2D
#
#onready var Target_Tile = load("res://Scenes/FIGHTMODE/B_Fightmode/Resources/Temporary_Tiles/Target_Tile.tscn")
#
#var MOUSE
#
#func _ready():
#	MOUSE = get_node("/root/MainNode/Battlefield/Mouse/Mouse_Cursor")
#
## Show active tile or not
## warning-ignore:unused_argument
#func _physics_process(delta):
#	if abs(get_local_mouse_position().x+MOUSE.Tile_offset.x) <= 32:
#		if abs(get_local_mouse_position().y+MOUSE.Tile_offset.y) <= 32:
#			if get_child_count()==0:
#				var add_child = Target_Tile.instance()
#				add_child(add_child, true)
#		else:
#			if get_child_count()>0:
#				get_child(0).queue_free()
#	else:
#		if get_child_count()>0:
#			get_child(0).queue_free()
#

onready var Target_Tile = load("res://Scenes/FIGHTMODE/B_Fightmode/Resources/Temporary_Tiles/Target_Tile.tscn")
var MOUSE

func _ready():
	MOUSE = get_node("/root/MainNode/Battlefield/Mouse_Cursor")
#	MOUSE = get_node("/root/Battlefield/Mouse_Cursor")
	
# Génère la tuile cible si le joueur parent est actif.
# - Sur la position avant de la souris si elle est fixe (tuile ciblée).
# - Sur la position arrière de la souris si elle est en rotation (ennemi ciblé).
# warning-ignore:unused_argument
func _physics_process(delta):
	if get_parent().get_parent().active_turn == true:
		if MOUSE.rotating == false:
			if (abs(MOUSE.get_node("Mouse_Front").global_position.x - self.global_position.x) <= 32
			&& abs(MOUSE.get_node("Mouse_Front").global_position.y - self.global_position.y) <= 32):
				if get_child_count()==0:
					var add_child = Target_Tile.instance()
					add_child(add_child, true)
#				else:
#					if get_child_count()>0:
#						get_child(0).queue_free()
			else:
				if get_child_count()>0:
					get_child(0).queue_free()
		else:
			if (abs(MOUSE.get_node("Mouse_Rear").global_position.x - self.global_position.x) <= 32
			&& abs(MOUSE.get_node("Mouse_Rear").global_position.y - self.global_position.y) <= 32):
					if get_child_count()==0:
						var add_child = Target_Tile.instance()
						add_child(add_child, true)
#					else:
#						if get_child_count()>0:
#							get_child(0).queue_free()
			else:
				if get_child_count()>0:
					get_child(0).queue_free()
			
