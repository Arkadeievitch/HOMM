extends ColorRect

var Unitsfolder_path : String = "res://Assets/TSCN/Units/"
var TURN : Node

func _ready():
	if has_node("/root/MainNode/Battlefield"):
		TURN = get_node("/root/MainNode/Battlefield/Turn")

func updateActiveIcon(ActiveCharacter):
	removeChildren()
		
	if TURN.get_child(ActiveCharacter).active_turn == true:
		var ActiveUnit : String = TURN.get_child(ActiveCharacter).name
		
		# Vérifie que le nom ne contient pas de chiffre (dans le cas d'unités en double...)
		if ActiveUnit.right(ActiveUnit.length()-1).is_valid_integer():
			ActiveUnit = ActiveUnit.left(ActiveUnit.length()-1)
			if ActiveUnit.right(1).is_valid_integer():
				ActiveUnit = ActiveUnit.left(ActiveUnit.length()-1)
		
		var ActiveIcon = load(str(Unitsfolder_path, ActiveUnit, "/icon.tscn"))
		ActiveIcon = ActiveIcon.instance()
		add_child(ActiveIcon, true)
		
		ActiveIcon.position = Vector2(80, 80)
		ActiveIcon.scale = Vector2(2.5, 2.5)
		
		self.color = TURN.get_child(ActiveCharacter).get_node("Unit_Counter/UnitCounterColor").color
		ActiveIcon.get_node("BG_Gradient").modulate = self.color

func removeChildren():
	if get_child_count() > 0 :
		for i in get_child_count():
			get_child(i).queue_free()
		