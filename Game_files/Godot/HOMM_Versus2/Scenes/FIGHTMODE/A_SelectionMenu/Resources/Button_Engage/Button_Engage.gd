extends Button

signal Engaged_pressed

func _ready():
# warning-ignore:return_value_discarded
	self.connect("button_up", self, "onEngagePressed")
	
func onEngagePressed():
	if has_node("/root/MainNode") == true:
		
		if (get_node("/root/MainNode/SelectionMenu/Table_Player1/Button_Heroes").get_child_count() > 0
		&& get_node("/root/MainNode/SelectionMenu/Table_Player2/Button_Heroes").get_child_count() > 0 ) :
			emit_signal("Engaged_pressed")
		else:
			print("Select a heroes for each side")