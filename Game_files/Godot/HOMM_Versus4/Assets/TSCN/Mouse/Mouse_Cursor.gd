extends Sprite

var rotating : bool = false
var Tile_position : Vector2
var Action_Position : Vector2
var Mouse_Inhibition : bool = false

var lastSaved_TargetPosition : Vector2

signal mouse_clic

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

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
		
		if rotating==true:
			Action_Position = get_node("Mouse_Front").global_position
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
			
		Theta = PI/4 + Phi
		self.rotation = Theta
	else:
		self.rotation = 0

# warning-ignore:unused_argument
func Target_Tile(Target_Tile_position):
#	TargetTilePresence = true
	lastSaved_TargetPosition = Target_Tile_position