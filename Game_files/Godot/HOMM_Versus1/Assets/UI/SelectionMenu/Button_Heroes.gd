extends Button

func _ready(): 
# warning-ignore:return_value_discarded
	self.connect("button_up", self, "HeroesSelection")

func HeroesSelection():
	# pré-requis 1 : node contenant la liste des unités associées au héros.
	# pré-requis 2 : tous les héros sont pré-instanciés dans une même scène.
	# pré-requis 3 : le code des scènes de créture est débuggé pour ne pas planter 
	# hors du mode combat
	var AllHeroes = load("res://Assets/Heroes/AllHeroesScene.tscn")
	add_child(AllHeroes.instance(), true)