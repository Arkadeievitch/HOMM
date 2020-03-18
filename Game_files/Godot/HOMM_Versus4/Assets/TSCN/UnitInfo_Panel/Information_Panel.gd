extends Node2D

func Fight_defineUnit(TurnUnitIndex):
	var TURN = get_node("/root/MainNode/Battlefield/Turn")
	get_node("Label_Name").text = TURN.NAME[TurnUnitIndex]
	get_node("Label_Damage").text = str("Damages : ", TURN.DAMAGE[TurnUnitIndex])
	get_node("Label_HP").Number = TURN.NUMBER[TurnUnitIndex]
	get_node("Label_HP").max_HP = TURN.MAX_HP[TurnUnitIndex]
	get_node("Label_HP").Total_HP = TURN.TOTAL_HP[TurnUnitIndex]
	get_node("Label_HP")._ready()
	get_node("Label_Displacement").text = str("Displacement : ", TURN.DISPLACEMENT[TurnUnitIndex])
	get_node("Label_Initiative").text = str("Initiative : ", TURN.INITIATIVE[TurnUnitIndex])

func Menu_defineUnit(Unit):
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