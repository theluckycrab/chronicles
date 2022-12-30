extends Node
class_name BaseAbility

var raw
var current

func _init(index):
	raw = Data.get_ability(index) 
	current = raw
	if current is Dictionary:
		current.effect = BaseEffect.new(raw.effect, raw.args)
	
func execute(host):
	match current.type:
		"buff":
			host.add_effect(current.effect)
