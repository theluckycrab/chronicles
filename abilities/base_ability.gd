extends Node
class_name BaseAbility

var raw
var current

func _init(data):
	if data is String:
		return
	raw = data
	current = raw
	if current.effect is Dictionary:
		current.effect = Data.get_effect(current.effect.index, current.effect.args)
		return
	current.effect = Data.get_effect(current.effect)
	
func execute(host):
	match current.type:
		"buff":
			host.add_effect(current.effect)
