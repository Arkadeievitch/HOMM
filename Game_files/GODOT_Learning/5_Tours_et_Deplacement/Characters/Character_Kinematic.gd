extends KinematicBody2D

var Priority : float = 0.0
var is_active : bool = false

var STATS

var Disp_Tiles = load("res://Resources/Ground_Tiles.tscn")
#var Target_Tile = load("res://Resources/Ground_Tile_target.tscn")

# Displacement variables
var velocity = Vector2()
var Current_X : int = self.global_position.x
var Current_Y : int = self.global_position.y
var Target_X : int = -10
var Target_Y : int = -10

signal End_of_Displacement

#_________________________________
func _ready():
	STATS = get_node("icon/Stats")
	Priority = STATS.INITIATIVE
	
	if get_node("/root/Battlefield") != null:
		$".".connect("Priorities_calculated", self, "_input")

#_________________________________
func _input(event):
	if Input.is_action_just_pressed("ui_leftclic"):
		
		if get_node("/root/Battlefield") != null:
			yield(get_parent(), "Priorities_calculated")
			if is_active == true:
				pass
			else:
				Priority += float(STATS.INITIATIVE) / float(get_parent().Char_number)

#_________________________________
func _process(delta):
	var speed : int = 5
	
	if is_active == true:
		update_position_and_target()
		velocity.x = speed * (Target_X - Current_X)
		velocity.y = speed * (Target_Y - Current_Y)
	
	if abs(self.global_position.x - Target_X) <= 12:
		end_displacement()
	else:
		move_and_slide(velocity)

#_________________________________
func update_position_and_target():
	
	Current_X = self.global_position.x
	Current_Y = self.global_position.y
	Target_X = round(get_global_mouse_position().x /24 ) * 24
	Target_Y = round(get_global_mouse_position().y /24 ) * 24
		
func end_displacement():
		velocity.x = 0
		velocity.y = 0
		is_active = false
		Priority = 0.0
		emit_signal("End_of_Displacement")