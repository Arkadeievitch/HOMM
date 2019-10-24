extends Node2D

# TURN QUEUE
class_name TurnQueue

onready var active_character : Fighter

# sort characters regarding their initiative
func initialize():
	var fighters = get_children()
	fighters.sort_custom(self, 'sort_fighters')
	for fighter in fighters:
		fighter.raise()
	active_character = get_child(0)

static func sort_fighters(a : Fighter, b : Fighter) -> bool:
	return a.stats.initiative > b.stats.initiative

func play_turn():
	yield(active_character.play_turn(), "completed")
	var new_index : int = (active_character.get_index() +1)  % get_child_count()
	active_character = get_child(new_index)
#