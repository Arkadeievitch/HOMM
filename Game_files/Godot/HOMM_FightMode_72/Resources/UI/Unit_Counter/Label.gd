extends Label

var CHARACTER
var STATS

func _ready():
	if get_parent().get_parent().get_parent() != null:
		CHARACTER = get_parent().get_parent().get_parent()
		STATS = CHARACTER.get_node("icon/Stats")

# warning-ignore:unused_argument
func _process(delta):
	if CHARACTER != null:
		self.text = String(STATS.NUMBER)