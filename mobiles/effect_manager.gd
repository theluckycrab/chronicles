extends Spatial

onready var host = get_parent()

func add_effect(e):
	var effect = BaseEffect.new(e)
	effect.host = host
	add_child(effect)
