extends KinematicBody2D

var Priority : float = 0.0
var is_active : bool = false

var STATS
var BATTLEFIELD

var Disp_Tiles = load("res://Resources/Ground_Tiles.tscn")
#var Target_Tile = load("res://Resources/Ground_Tile_target.tscn")

# Displacement variables
var velocity = Vector2()
var Current_X : int = self.global_position.x
var Current_Y : int = self.global_position.y
var Target_X : int = -10
var Target_Y : int = -10


#_________________________________
func _ready():
	STATS = get_node("icon/Stats")
	BATTLEFIELD = get_parent().get_parent()
	Priority = STATS.INITIATIVE
	connect_Character_to_signals()

#_________________________________
func _input(event):
	if Input.is_action_just_pressed("ui_leftclic"):
		print("Character")
		if is_active == true:
			set_velocity()
			print("Character end - increase velocity")
		else:
			increment_Priority()
			print("Character end - increase priority")
		
#_________________________________
func _process(delta):
	if abs(self.global_position.x - Target_X) <= 12:
		end_displacement()
	else:
		displacement()
		
#========================================================
#_________________________________
func set_velocity():
	var speed : int = 5
	
	Current_X = self.global_position.x
	Current_Y = self.global_position.y
	Target_X = round(get_global_mouse_position().x /24 ) * 24
	Target_Y = round(get_global_mouse_position().y /24 ) * 24
	
	velocity.x = speed * (Target_X - Current_X)
	velocity.y = speed * (Target_Y - Current_Y)

func displacement():
	move_and_slide(velocity)

func end_displacement():
		velocity.x = 0
		velocity.y = 0
		is_active = false
		Priority = 0.0
		BATTLEFIELD.wait_for_action = false

func increment_Priority():
	Priority += float(STATS.INITIATIVE) / float(get_parent().Char_number)
	
func connect_Character_to_signals():
	if get_node("/root/Battlefield") != null:
		$".".connect("Priorities_calculated", self, "connect_Character_to_signals")
	
	