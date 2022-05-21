extends Ability

var active : bool = false


func execute(item: Item, host: Object) -> void:
	if !active:
		host.add_effect(item, "treasure_sense_effect")
	else:
		host.remove_effect("treasure_sense_effect")
	active = !active
	pass
