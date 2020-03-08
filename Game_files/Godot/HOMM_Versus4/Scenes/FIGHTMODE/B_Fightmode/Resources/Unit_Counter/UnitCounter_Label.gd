extends Label

var CHARACTER
var STATS

func _ready():
	CHARACTER = get_parent().get_parent().get_parent() 
	if has_node("/root/MainNode/Battlefield"):
		STATS = CHARACTER.get_node("icon/Stats")
		self.text = String(STATS.NUMBER)