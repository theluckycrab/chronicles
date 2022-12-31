extends Spatial

onready var host = get_parent()

func add_effect(effect):
	effect.host = host
	add_child(effect)
	effect.execute()
