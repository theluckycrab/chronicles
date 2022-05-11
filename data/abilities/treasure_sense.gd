extends Ability

var active : bool = false


func execute(item: Item, host: Object) -> void:
	if !active:
		host.add_passive(item, "Treasure Sense")
	else:
		host.remove_passive("Treasure Sense")
	active = !active
	pass
