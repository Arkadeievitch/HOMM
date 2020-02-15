extends Label

var CHARACTER
var STATS

func _ready():
	var parent =get_parent().get_parent().get_parent() 
	if parent != null:
		CHARACTER = get_parent().get_parent().get_parent().get_parent()
		STATS = CHARACTER.get_node("icon/Stats")

# warning-ignore:unused_argument
func _process(delta):
	if CHARACTER != null:
		self.text = String(STATS.NUMBER)