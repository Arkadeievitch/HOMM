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
	get_parent.connect("rotate_N", self, "rotation_N")
# warning-ignore:return_value_discarded
	get_parent.connect("rotate_NE", self, "rotation_NE")
# warning-ignore:return_value_discarded
	get_parent.connect("rotate_NW", self, "rotation_NW")
# warning-ignore:return_value_discarded
	get_parent.connect("rotate_S", self, "rotation_S")
# warning-ignore:return_value_discarded
	get_parent.connect("rotate_SE", self, "rotation_SE")
# warning-ignore:return_value_discarded
	get_parent.connect("rotate_SW", self, "rotation_SW")
# warning-ignore:return_value_discarded
	get_parent.connect("rotate_E", self, "rotation_E")
# warning-ignore:return_value_discarded
	get_parent.connect("rotate_W", self, "rotation_W")
	
func rotation_N():
	rotation_applied = true
	Tile_offset = Vector2(0, 32)
	Tile_target = Vector2(	self.global_position.x + Tile_offset.x, 
							self.global_position.y + Tile_offset.y)
	Action_target = Vector2(	self.global_position.x - Tile_offset.x, 
								self.global_position.y - Tile_offset.y)
	if Input.is_action_just_pressed("ui_leftclic"):
		emit_signal("mouse_clic", Action_target, Tile_target)
func rotation_NE():
	rotation_applied = true
	Tile_offset = Vector2(-24, 24)
	Tile_target = Vector2(	self.global_position.x + Tile_offset.x, 
							self.global_position.y + Tile_offset.y)
	Action_target = Vector2(	self.global_position.x - Tile_offset.x, 
								self.global_position.y - Tile_offset.y)
	if Input.is_action_just_pressed("ui_leftclic"):
		emit_signal("mouse_clic", Action_target, Tile_target)
func rotation_NW():
	rotation_applied = true
	Tile_offset = Vector2(24, 24)
	Tile_target = Vector2(	self.global_position.x + Tile_offset.x, 
							self.global_position.y + Tile_offset.y)
	Action_target = Vector2(	self.global_position.x - Tile_offset.x, 
								self.global_position.y - Tile_offset.y)
	if Input.is_action_just_pressed("ui_leftclic"):
		emit_signal("mouse_clic", Action_target, Tile_target)
func rotation_S():
	rotation_applied = true
	Tile_offset = Vector2(0, -32)
	Tile_target = Vector2(	self.global_position.x + Tile_offset.x, 
							self.global_position.y + Tile_offset.y)
	Action_target = Vector2(	self.global_position.x - Tile_offset.x, 
								self.global_position.y - Tile_offset.y)
	if Input.is_action_just_pressed("ui_leftclic"):
		emit_signal("mouse_clic", Action_target, Tile_target)
func rotation_SE():
	rotation_applied = true
	Tile_offset = Vector2(-24, -24)
	Tile_target = Vector2(	self.global_position.x + Tile_offset.x, 
							self.global_position.y + Tile_offset.y)
	Action_target = Vector2(	self.global_position.x - Tile_offset.x, 
								self.global_position.y - Tile_offset.y)
	if Input.is_action_just_pressed("ui_leftclic"):
		emit_signal("mouse_clic", Action_target, Tile_target)
func rotation_SW():
	rotation_applied = true
	Tile_offset = Vector2(24, -24)
	Tile_target = Vector2(	self.global_position.x + Tile_offset.x, 
							self.global_position.y + Tile_offset.y)
	Action_target = Vector2(	self.global_position.x - Tile_offset.x, 
								self.global_position.y - Tile_offset.y)
	if Input.is_action_just_pressed("ui_leftclic"):
		emit_signal("mouse_clic", Action_target, Tile_target)
func rotation_E():
	rotation_applied = true
	Tile_offset = Vector2(32, 0)
	Tile_target = Vector2(	self.global_position.x + Tile_offset.x, 
							self.global_position.y + Tile_offset.y)
	Action_target = Vector2(	self.global_position.x - Tile_offset.x, 
								self.global_position.y - Tile_offset.y)
	if Input.is_action_just_pressed("ui_leftclic"):
		emit_signal("mouse_clic", Action_target, Tile_target)
func rotation_W():
	rotation_applied = true
	Tile_offset = Vector2(-32, 0)
	Tile_target = Vector2(	self.global_position.x + Tile_offset.x, 
							self.global_position.y + Tile_offset.y)
	Action_target = Vector2(	self.global_position.x - Tile_offset.x, 
								self.global_position.y - Tile_offset.y)
	if Input.is_action_just_pressed("ui_leftclic"):
emit_signal("mouse_clic", Action_target, Tile_target)