extends Node

var recursiveLoop_counter : int = 0

func updateChronology(tempoPriorities):
	var internPriorities = tempoPriorities
	var Priorities_order = []
	for i in internPriorities.size():
		Priorities_order.append(0)
	recursiveLoop_counter = 0
	OrderPriorities(internPriorities, Priorities_order)
	
	for i in range(1, min(internPriorities.size(), get_child_count())):
		get_node(str("ColorRect_NextTurn", i)).updateIcon(Priorities_order[i])
		
	if internPriorities.size() < get_child_count():
		var empty_slots : int = get_child_count() - internPriorities.size()
		for i in empty_slots:
			get_child(get_child_count()-1-i).removeChildren()

func OrderPriorities(intPriorities, Priorities_order):
	var Highest_priority: float = -1
	var ActiveCharacter: int = 0
	
	for i in intPriorities.size():
		if intPriorities[i] > Highest_priority:
			Highest_priority = intPriorities[i] 
			ActiveCharacter = i
	
	Priorities_order[recursiveLoop_counter] = ActiveCharacter
	recursiveLoop_counter+=1
	
	intPriorities[ActiveCharacter] = -1
	if intPriorities.size()-recursiveLoop_counter > 0:
		OrderPriorities(intPriorities, Priorities_order)
	else:
		return Priorities_order