extends Node2D

var recursiveLoop_counter : int = 0

func updateChronology(internPriorities):
	var Priorities_order = []
	for i in internPriorities.size():
		Priorities_order.append(0)
	recursiveLoop_counter = 0
	OrderPriorities(internPriorities, Priorities_order)
	
	get_node("ColorRect_Active").updateActiveIcon(Priorities_order[0])
	for i in range(1, min(internPriorities.size(), get_child_count())):
		get_node(str("ColorRect_NextTurn", i)).updateIcon(Priorities_order[i])
		
	if internPriorities.size() < get_child_count():
		var empty_slots : int = get_child_count() - internPriorities.size()
		for i in empty_slots:
			get_child(get_child_count()-1-i).removeChildren()

func OrderPriorities(internPriorities, Priorities_order):
	var Highest_priority: float = -1
	var ActiveCharacter: int = 0
	
	for i in internPriorities.size():
		if internPriorities[i] > Highest_priority:
			Highest_priority = internPriorities[i] 
			ActiveCharacter = i
	
	Priorities_order[recursiveLoop_counter] = ActiveCharacter
	recursiveLoop_counter+=1
	
	internPriorities[ActiveCharacter] = -1
	if internPriorities.size()-recursiveLoop_counter > 0:
		OrderPriorities(internPriorities, Priorities_order)
	else:
		return Priorities_order