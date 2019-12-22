extends YSort

class_name TurnQueue

onready var active_character : Creature

# sort characters regarding their priority
func initialize():
	var fighting_units = get_children()
	fighting_units.sort_custom(self, 'sort_fighters')
	for fighting_units in fighting_units:
		fighting_units.raise()
	active_character = get_child(0)

static func sort_fighters(a : Creature, b : Creature) -> bool:
	return a.stats.priority > b.stats.priority
