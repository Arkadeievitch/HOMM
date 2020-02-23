extends Node2D

var Unit : Node

func defineUnit(UnitStatsNode):
	Unit = UnitStatsNode
	get_node("Label_Name").text = Unit.NAME
	get_node("Label_Damage").text = str("Damages : ", Unit.DAMAGE)
	get_node("Label_HP").Number = Unit.NUMBER
	get_node("Label_HP").max_HP = Unit.MAX_HP
	get_node("Label_HP").Total_HP = Unit.TOTAL_HP
	get_node("Label_HP")._ready()
	get_node("Label_Displacement").text = str("Displacement : ", Unit.DISPLACEMENT)
	get_node("Label_Initiative").text = str("Initiative : ", Unit.INITIATIVE)

# warning-ignore:unused_argument
func _input(event):
	if Input.is_action_just_pressed("ui_rightclic"):
		self.queue_free()