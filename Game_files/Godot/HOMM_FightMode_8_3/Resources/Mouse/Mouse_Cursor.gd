extends Node2D

var Tile_target : Vector2
var Action_target : Vector2
var Tile_offset : Vector2

signal mouse_clic

var rotation_applied : bool = false

func _ready():
    # Changes only the arrow shape of the cursor.
    # This is similar to changing it in the project settings.
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	connect_to_rotations()

# warning-ignore:unused_argument
func _process(delta):
	self.global_position = Vector2(	get_global_mouse_position().x, 
									get_global_mouse_position().y)
	if rotation_applied == false:
		Tile_offset = Vector2(24, -24)
		Tile_target = Vector2(	self.global_position.x + Tile_offset.x, 
								self.global_position.y + Tile_offset.y)
		Action_target = Tile_target
	
	if Input.is_action_just_pressed("ui_leftclic") && rotation_applied == false:
		emit_signal("mouse_clic", Action_target, Tile_target)
	
	rotation_applied = false

func connect_to_rotations():
# warning-ignore:return_value_discarded
	get_node("Rotations").get_child(0).connect("rotate_1", self, "rotation_1")
# warning-ignore:return_value_discarded
	get_node("Rotations").get_child(1).connect("rotate_2", self, "rotation_2")
# warning-ignore:return_value_discarded
	get_node("Rotations").get_child(2).connect("rotate_3", self, "rotation_3")
# warning-ignore:return_value_discarded
	get_node("Rotations").get_child(3).connect("rotate_4", self, "rotation_4")
# warning-ignore:return_value_discarded
	get_node("Rotations").get_child(4).connect("rotate_5", self, "rotation_5")
# warning-ignore:return_value_discarded
	get_node("Rotations").get_child(5).connect("rotate_6", self, "rotation_6")
# warning-ignore:return_value_discarded
	get_node("Rotations").get_child(6).connect("rotate_7", self, "rotation_7")
# warning-ignore:return_value_discarded
	get_node("Rotations").get_child(7).connect("rotate_8", self, "rotation_8")
	
func rotation_1():
	rotation_applied = true
	Tile_offset = Vector2(0, 32)
	Tile_target = Vector2(	self.global_position.x + Tile_offset.x, 
							self.global_position.y + Tile_offset.y)
	Action_target = Vector2(	self.global_position.x - Tile_offset.x, 
								self.global_position.y - Tile_offset.y)
	if Input.is_action_just_pressed("ui_leftclic"):
		emit_signal("mouse_clic", Action_target, Tile_target)
func rotation_2():
	rotation_applied = true
	Tile_offset = Vector2(-24, 24)
	Tile_target = Vector2(	self.global_position.x + Tile_offset.x, 
							self.global_position.y + Tile_offset.y)
	Action_target = Vector2(	self.global_position.x - Tile_offset.x, 
								self.global_position.y - Tile_offset.y)
	if Input.is_action_just_pressed("ui_leftclic"):
		emit_signal("mouse_clic", Action_target, Tile_target)
func rotation_3():
	rotation_applied = true
	Tile_offset = Vector2(-32, 0)
	Tile_target = Vector2(	self.global_position.x + Tile_offset.x, 
							self.global_position.y + Tile_offset.y)
	Action_target = Vector2(	self.global_position.x - Tile_offset.x, 
								self.global_position.y - Tile_offset.y)
	if Input.is_action_just_pressed("ui_leftclic"):
		emit_signal("mouse_clic", Action_target, Tile_target)
func rotation_4():
	rotation_applied = true
	Tile_offset = Vector2(-24, -24)
	Tile_target = Vector2(	self.global_position.x + Tile_offset.x, 
							self.global_position.y + Tile_offset.y)
	Action_target = Vector2(	self.global_position.x - Tile_offset.x, 
								self.global_position.y - Tile_offset.y)
	if Input.is_action_just_pressed("ui_leftclic"):
		emit_signal("mouse_clic", Action_target, Tile_target)
func rotation_5():
	rotation_applied = true
	Tile_offset = Vector2(0, -32)
	Tile_target = Vector2(	self.global_position.x + Tile_offset.x, 
							self.global_position.y + Tile_offset.y)
	Action_target = Vector2(	self.global_position.x - Tile_offset.x, 
								self.global_position.y - Tile_offset.y)
	if Input.is_action_just_pressed("ui_leftclic"):
		emit_signal("mouse_clic", Action_target, Tile_target)
func rotation_6():
	rotation_applied = true
	Tile_offset = Vector2(24, -24)
	Tile_target = Vector2(	self.global_position.x + Tile_offset.x, 
							self.global_position.y + Tile_offset.y)
	Action_target = Vector2(	self.global_position.x - Tile_offset.x, 
								self.global_position.y - Tile_offset.y)
	if Input.is_action_just_pressed("ui_leftclic"):
		emit_signal("mouse_clic", Action_target, Tile_target)
func rotation_7():
	rotation_applied = true
	Tile_offset = Vector2(32, 0)
	Tile_target = Vector2(	self.global_position.x + Tile_offset.x, 
							self.global_position.y + Tile_offset.y)
	Action_target = Vector2(	self.global_position.x - Tile_offset.x, 
								self.global_position.y - Tile_offset.y)
	if Input.is_action_just_pressed("ui_leftclic"):
		emit_signal("mouse_clic", Action_target, Tile_target)
func rotation_8():
	rotation_applied = true
	Tile_offset = Vector2(24, 24)
	Tile_target = Vector2(	self.global_position.x + Tile_offset.x, 
							self.global_position.y + Tile_offset.y)
	Action_target = Vector2(	self.global_position.x - Tile_offset.x, 
								self.global_position.y - Tile_offset.y)
	if Input.is_action_just_pressed("ui_leftclic"):
		emit_signal("mouse_clic", Action_target, Tile_target)