extends Sprite

var PassiveButton = load("res://Scenes/FIGHTMODE/A_SelectionMenu/Resources/Button_Engage/ENGAGE_BUTTON_Passive.png")
var PressedButton = load("res://Scenes/FIGHTMODE/A_SelectionMenu/Resources/Button_Engage/ENGAGE_BUTTON_Pressed.png")

func _ready():
	self.texture = PassiveButton
# warning-ignore:return_value_discarded
	get_parent().connect("button_down", self, "toggle_Button_down")
# warning-ignore:return_value_discarded
	get_parent().connect("button_up", self, "toggle_Button_up")

func toggle_Button_down():
	self.texture = PressedButton
	
func toggle_Button_up():
	self.texture = PassiveButton