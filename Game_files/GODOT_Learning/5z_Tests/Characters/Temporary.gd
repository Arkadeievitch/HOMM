extends Position2D

#_________________________________
func _ready():
	
	print("Temporary/      ready()")
	$".".connect("Priorities_calculated", self, "_input")
	
	yield(get_parent().get_parent(), "Priorities_calculated")
	print("Temporary/      ready()/yield")
	
	

#_________________________________
func _input(event):
	
	if Input.is_action_just_pressed("ui_leftclic"):
				
		print("Temporary/      input(event)/leftclic")
		yield(get_parent().get_parent(), "Priorities_calculated")
		print("Temporary/      input(event)/leftclic & yield")