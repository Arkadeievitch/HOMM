extends Sprite
var Faction_Title_path : String = "res://Assets/TSCN/Factions/Faction_Labels/Label_"
export var NAME : String

var Icon_halfSize : Vector2

func _ready():
	Faction_Title_path = str(Faction_Title_path, NAME, ".tscn")
	print(Faction_Title_path)

# warning-ignore:unused_argument
func _process(delta):
	if has_node("/root/MainNode/SelectionMenu"):
		var parentsScale = get_parent().get_parent().scale*get_parent().scale
		Icon_halfSize = Vector2(ceil(132*self.scale.x*parentsScale.x), 
								ceil(132*self.scale.y*parentsScale.y))
		if (abs(get_global_mouse_position().x - self.global_position.x) <= abs(Icon_halfSize.x)
		&& abs(get_global_mouse_position().y - self.global_position.y) <= abs(Icon_halfSize.y)):
			
			var Faction_Title = load(Faction_Title_path)
			Faction_Title = Faction_Title.instance()
			self.add_child(Faction_Title, true)
			Faction_Title.global_position.y += Icon_halfSize.y
		else:
			if get_child_count() > 0:
				for i in get_child_count():
					get_child(i).queue_free()