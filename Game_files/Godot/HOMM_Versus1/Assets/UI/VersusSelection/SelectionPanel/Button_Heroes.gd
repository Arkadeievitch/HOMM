extends Button

func _ready(): 
# warning-ignore:return_value_discarded
	self.connect("button_up", self, "HeroesSelection")

# warning-ignore:unused_argument
func _input(event):
	if (Input.is_action_just_pressed("ui_leftclic") 
		&& has_node("/root/MainNode/SelectionMenu")):
		var MOUSE = get_node("/root/MainNode/SelectionMenu/Mouse_Cursor")
		if (abs(MOUSE.global_position.x-self.rect_global_position.x-64)<64
		&& abs(MOUSE.global_position.y-self.rect_global_position.y-64)<64
		&& get_parent().get_node("Heroes").get_child_count() <1):
			emit_signal("button_up")

func HeroesSelection():
	# pré-requis 1 : node contenant la liste des unités associées au héros.
	# pré-requis 2 : tous les héros sont pré-instanciés dans une même scène.
	# pré-requis 3 : le code des scènes de créture est débuggé pour ne pas planter 
	# hors du mode combat
	var AllHeroes = load("res://Assets/Heroes/AllHeroesScene.tscn")
	get_parent().get_node("Heroes").add_child(AllHeroes.instance(), true)
	self.text = ""
	get_node("Color_Heroes").changeColor(1)