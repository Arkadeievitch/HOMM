extends Tween

signal user_tween_completed

func _ready():
	# warning-ignore:return_value_discarded
	self.connect("tween_completed", self, "emit_tweenCompletion")
	
# warning-ignore:unused_argument
func emit_tweenCompletion(ObjectArrow, b):
	var Target = get_node("/root/MainNode/Battlefield/Turn").MouseActionTarget
	
	emit_signal("user_tween_completed", ObjectArrow, Target)