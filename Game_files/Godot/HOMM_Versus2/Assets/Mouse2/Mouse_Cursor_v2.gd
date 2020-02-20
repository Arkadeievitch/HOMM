extends Sprite

var rotating : bool = false
var Tile_position : Vector2
var Action_Position : Vector2

signal mouse_clic

# Cette variable est lue par les tuiles temporaires pour générer la 
# tuile active  à l'avant ou l'arrière du curseur selon l'objet pointé.
# warning-ignore:unused_argument
func _process(delta):
	self.global_position = get_global_mouse_position()
	if abs(self.rotation) < 0.01:
		rotating = false
	else:
		rotating = true

# warning-ignore:unused_argument
func _input(event):
	if Input.is_action_just_pressed("ui_leftclic"):
		Action_Position = get_node("Mouse_Front").global_position
		emit_signal("mouse_clic", Action_Position, Tile_position)

func Rotation_Pointeur(Character_position):
	var deltax : float = float(self.global_position.x)-float(Character_position.x)
	var deltay : float = float(self.global_position.y)-float(Character_position.y)
	if abs(deltax) < 63 && abs(deltay) < 63:
		var Theta : float 
		var Phi : float 
		if deltay < 0:
			Phi = acos(-deltax/sqrt(deltax*deltax + deltay*deltay))
		else:
			Phi = -acos(-deltax/sqrt(deltax*deltax + deltay*deltay))
			
		Theta = PI/4 + Phi
		self.rotation = Theta
	else:
		self.rotation = 0
