extends Sprite

var Cursor_path = "res://Assets/TSCN/Mouse/Mouse_Cursor_v4_48x48.png"
var RedCursor_path = "res://Assets/TSCN/Mouse/Mouse_Cursor_v4_48x48_agression.png"

var rotating : bool = false
var Tile_position : Vector2
var Action_Position : Vector2
var Mouse_Inhibition : bool = false

var lastSaved_TargetPosition : Vector2

var FRONT_MOUSE : Node

signal mouse_clic

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	FRONT_MOUSE = get_node("Mouse_Front")

# Cette variable est lue par les tuiles temporaires pour générer la 
# tuile active  à l'avant ou l'arrière du curseur selon l'objet pointé.
# warning-ignore:unused_argument
func _process(delta):
	if has_node("/root/MainNode/Battlefield"):
		self.global_position = get_global_mouse_position()
	elif has_node("/root/MainNode/SelectionMenu"):
		self.global_position = get_global_mouse_position() + Vector2(-32, 32)
	else:
		self.global_position = get_global_mouse_position() + Vector2(-32, 32)

	if abs(self.rotation) < 0.01:
		rotating = false
	else:
		rotating = true

# warning-ignore:unused_argument
func _input(event):
	if (Input.is_action_just_pressed("ui_leftclic")
		&& Mouse_Inhibition == false):
		
		if FRONT_MOUSE.found_target ==true:
			Action_Position = FRONT_MOUSE.global_position
			Tile_position = get_node("Mouse_Rear").global_position
			lastSaved_TargetPosition = Vector2(0, 0)
		else:
			Tile_position = lastSaved_TargetPosition
			lastSaved_TargetPosition = Vector2(0, 0)
			Action_Position = Tile_position
		emit_signal("mouse_clic", Action_Position, Tile_position)

func Rotation_Pointeur(Character_position):
	var deltax : float = float(self.global_position.x)-float(Character_position.x)
	var deltay : float = float(self.global_position.y)-float(Character_position.y)
	if abs(deltax) < 64 && abs(deltay) < 64:
		var Theta : float 
		var Phi : float 
		if deltay < 0:
			Phi = acos(-deltax/sqrt(deltax*deltax + deltay*deltay))
		else:
			if sqrt(deltax*deltax + deltay*deltay) !=0:
				Phi = -acos(-deltax/sqrt(deltax*deltax + deltay*deltay))
			
		Theta = PI/4 +  PI/4*round((Phi)/(PI/4))
		self.rotation = Theta
	else:
		self.rotation = 0

# warning-ignore:unused_argument
func Target_Tile(Target_Tile_position):
	lastSaved_TargetPosition = Target_Tile_position

func load_Redtexture():
	self.texture = load(RedCursor_path)
func load_Standardtexture():
	self.texture = load(Cursor_path)
