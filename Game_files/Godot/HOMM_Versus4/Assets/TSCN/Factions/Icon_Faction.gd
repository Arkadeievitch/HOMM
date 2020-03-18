extends Sprite
var Faction_Title_path : String = "res://Assets/TSCN/Factions/Faction_Labels/Label_"
export var NAME : String

var IconSize : Vector2

func _ready():
	IconSize = get_node("Container").rect_size
	Faction_Title_path = str(Faction_Title_path, NAME, ".tscn")
	print(Faction_Title_path)

# warning-ignore:unused_argument
func _input(event):
	if Input.is_action_just_pressed("ui_rightclic"):
		if get_parent().get_parent().has_node("AllHeroesScene"):
			IconSize = Vector2(135, 135)*scale
			if (abs(get_global_mouse_position().x - self.global_position.x) < abs(IconSize.x)
			&& abs(get_global_mouse_position().y - self.global_position.y) < abs(IconSize.y)):
				var Faction_Title = load(Faction_Title_path)
				Faction_Title = Faction_Title.instance()
				self.add_child(Faction_Title, true)
				
				Faction_Title.rect_position = Vector2(-3.1*IconSize.x, 3.4*IconSize.y)