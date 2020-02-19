extends Button

signal Engaged_pressed

func _ready():
# warning-ignore:return_value_discarded
	self.connect("button_up", self, "onEngagePressed")
	
func onEngagePressed():
	if (has_node("/root/MainNode") == true
	&& has_node("/root/MainNode/SelectionMenu/Table_Player1/Heroes/AllHeroesScene")
	&& has_node("/root/MainNode/SelectionMenu/Table_Player2/Heroes/AllHeroesScene")):
		
			var Heroes1 = get_node("/root/MainNode/SelectionMenu/Table_Player1/Heroes/AllHeroesScene")
			var Heroes2 = get_node("/root/MainNode/SelectionMenu/Table_Player2/Heroes/AllHeroesScene")
			
			if (Heroes1.get_child_count() ==1
			&& Heroes2.get_child_count() ==1 ) :
				emit_signal("Engaged_pressed")
			else:
				print("Select a heroes for each side")