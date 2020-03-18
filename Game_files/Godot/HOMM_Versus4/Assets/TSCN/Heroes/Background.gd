extends Sprite

# Cache et restaure les éléments des panneaux de sélection.
# (Choix de couleur et du bot)
func _ready():
	if has_node("/root/MainNode/SelectionMenu"):
		var children_count = get_parent().get_parent().get_parent().get_child_count()
		var Table = get_parent().get_parent().get_parent()
		for i in children_count:
			if Table.get_child(i).name != get_parent().get_parent().name:
				Table.get_child(i).visible = false

func _exit_tree():
	if has_node("/root/MainNode/SelectionMenu"):
		var children_count = get_parent().get_parent().get_parent().get_child_count()
		var Table = get_parent().get_parent().get_parent()
		for i in children_count:
			if Table.get_child(i).name != "Button_Heroes":
				Table.get_child(i).visible = true