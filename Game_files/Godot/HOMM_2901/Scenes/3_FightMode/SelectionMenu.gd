extends Node

# A decouper dans les Nodes adaptés:
# fonctions attachées au bouton de sélection des héros
func _ready(): 
	self.connect("button_up", self, "HeroesSelection")

func HeroesSelection():
	# pré-requis 1 : node contenant la liste des unités associées au héros.
	# pré-requis 2 : tous les héros sont pré-instanciés dans une même scène.
	# pré-requis 3 : le code des scènes de créture est débuggé pour ne pas planter 
	# hors du mode combat
	var AllHeroes = load("Heroes/AllHeroesScene")
	add_child(AllHeroes.instance(), true)
	
# fonctions attachées à chaque icône de héros.
func _input(event):
	if Input.is_action_just_pressed("leftclic"):
		clearCurrent()
		HeroesSelected()
	if Input.is_action_just_pressed("rightclic"):
		clearCurrent()
		HeroesInformation()

func HeroesSelected():
	if (abs(get_local_mouse_position.x) < 32
	&& abs(get_local_mouse_position.y) < 32):
		# move Heroes icon to its expected position
		self.global_position = Vector2(400, 400)
		
		# display Units counters, names and icons
		var UNITS = get_node("default_Army")
		var UnitsName = UNITS.Names
		var UnitsCounters = UNITS.Counters
		var NumberOfUnits = UnitsName.size()
		
		var UNIT_DISPLAY = get_parent().get_node("Units")
		for i in NumberOfUnits:
			var UnitNameDisplayed = UNIT_DISPLAY.get_child(i)
			var UnitCounterDisplayed = UnitNameDisplayed.get_node("Label_Counter")
			var UnitIconDisplayed = load("pathtocreaturefolder"&& UnitsName[i] && ".tscn")
			
			UnitNameDisplayed.text = UnitsName[i]
			UnitCounterDisplayed.text = UnitsCounters[i]
			var new_child = add_child(UnitIconDisplayed.instance(), true)
			new_child.global_position = Vector2(600, 350+(i+64)*128)
	else:
		# remove if not selected
		self.queue_free()

func HeroesInformation():
	if (abs(get_local_mouse_position.x) < 32
	&&abs(get_local_mouse_position.y) < 32):
		var InformationPanel = load("InformationPanel")
		add_child(InformationPanel.instance(), true)

clearCurrent():
	get_child(0).queue_free()