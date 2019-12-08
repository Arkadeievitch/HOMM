extends KinematicBody2D


#_________________________________
func _ready():
	
	print("Character_K/    ready()")
	$".".connect("Priorities_calculated", self, "_input")

#_________________________________
func _input(event):
	if Input.is_action_just_pressed("ui_leftclic"):
		
		print("Character_K/    input(event)/leftclic")
		yield(get_parent(), "Priorities_calculated")
		print("Character_K/    input(event)/leftclic & yield")

#_________________________________
func _process(delta):
	
	if Input.is_action_just_pressed("ui_leftclic"):
		print("Character_K/    process(delta)/leftclic")