extends Label

var MOUSE : Node

func _ready():
	MOUSE = get_node("/root/MainNode/SelectionMenu/Mouse_Cursor")
		
# warning-ignore:unused_argument
func _input(event):
	if Input.is_action_just_pressed("ui_leftclic"):
		var HEROES = get_parent().get_parent().get_node("Heroes")
		if HEROES.get_child_count()>0:
			self.text = ""
	
		if (get_parent().get_parent().get_parent().get_parent().has_node("SelectionMenu")):
			if (MOUSE.global_position.x-self.rect_global_position.x <self.rect_size.x
			&& MOUSE.global_position.x-self.rect_global_position.x >0
			&& abs(MOUSE.global_position.y-self.rect_global_position.y) <self.rect_size.y
			&& MOUSE.global_position.y-self.rect_global_position.y >0):
				
				var HeroesNode = get_parent().get_parent().get_node("Heroes")
				
				if HeroesNode.get_child_count() <1:
					HeroesSelection()
				elif HeroesNode.has_node("AllHeroesScene"):
					if HeroesNode.get_node("AllHeroesScene").get_child_count() <2:
						HeroesSelection()

func HeroesSelection():
	# pré-requis 1 : node contenant la liste des unités associées au héros.
	# pré-requis 2 : tous les héros sont pré-instanciés dans une même scène.
	# pré-requis 3 : le code des icônes de créture est débuggé pour ne pas planter 
	# hors du mode combat
	var AllHeroes = load("res://Assets/TSCN/Heroes/AllHeroesScene.tscn")
	var HeroesNode
	
	if get_parent().has_node("Heroes"):
		HeroesNode = get_parent().get_node("Heroes")
	else:
		HeroesNode = get_parent().get_parent().get_node("Heroes")
	
	if HeroesNode.get_child_count() > 0:
		for i in HeroesNode.get_child_count():
			HeroesNode.get_child(i).queue_free()
		yield(get_tree(), "idle_frame")
	
	var HeroesBoard = AllHeroes.instance()
	HeroesNode.add_child(HeroesBoard, true)
	if self.rect_global_position.x < get_viewport().size.x/2:
		HeroesBoard.global_position = Vector2(0, 0)
	else:
		HeroesBoard.global_position = Vector2(get_viewport().size.x-768, 0)
	self.text = ""