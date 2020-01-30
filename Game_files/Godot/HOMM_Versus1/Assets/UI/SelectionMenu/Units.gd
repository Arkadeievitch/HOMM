extends Control

func GenerateArmySummary():
	clearCurrentChildren()
	pass

func clearCurrentChildren():
	for i in get_child_count():
		get_child(i).queue_free()