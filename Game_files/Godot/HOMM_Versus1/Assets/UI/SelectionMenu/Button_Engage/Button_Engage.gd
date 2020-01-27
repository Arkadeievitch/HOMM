extends Button

signal Engaged_pressed

func _ready():
# warning-ignore:return_value_discarded
	self.connect("button_up", self, "onEngagePressed")
	
func onEngagePressed():	
	if get_parent() != null:
		var Side
		var IA
		var TileColor
		var Units_name
		var Unit_counters
		
		var MENU = get_parent()
		var UNITS1 = MENU.get_node("Table_Player1/Units")
		var UNITS2 = MENU.get_node("Table_Player2/Units")
		
		var counter = UNITS1.get_child_count()
		for i in counter:
			var Unit_name = UNITS1.get_child(i).text
			var Unit_number = int(UNITS1.get_child(i).get_node("UnitCounter").text)
			
			
			
		
		emit_signal("Engaged_pressed", Side, IA, TileColor, Units_name, Unit_counters)