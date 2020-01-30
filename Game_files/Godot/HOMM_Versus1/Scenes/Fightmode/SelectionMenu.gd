extends Control

var SelectionMenu : bool = false
var Fightmode : 	bool = false
# A decouper dans les Nodes adaptés:
# fonctions attachées au bouton de sélection des héros
func _ready(): 
	if get_node("/root/MainNode/SelectionMenu") != null:
		SelectionMenu = true
		Fightmode = false
	elif get_node("/root/MainNode/Battlefield") != null:
		SelectionMenu = false
		Fightmode = true
	
	if SelectionMenu == true:
		self.connect("button_up", self, "HeroesSelection")

func HeroesSelection():
	# pré-requis 1 : node contenant la liste des unités associées au héros.
	# pré-requis 2 : tous les héros sont pré-instanciés dans une même scène.
	# pré-requis 3 : le code des scènes de créture est débuggé pour ne pas planter 
	# hors du mode combat
	var AllHeroes = load("/root/Assets/Heroes/AllHeroesScene")
	add_child(AllHeroes.instance(), true)
	
# fonctions attachées à chaque icône de héros.
func _input(event):
	if Input.is_action_just_pressed("ui_rightclic"):
		clearCurrent()
		HeroesInformation()

func HeroesInformation():
	if (abs(get_local_mouse_position().x) < 32
	&&abs(get_local_mouse_position().y) < 32):
		var InformationPanel = load("/root/Assets/Heroes/InformationPanel.tscn")
		add_child(InformationPanel.instance(), true)

func clearCurrent():
	get_child(0).queue_free()