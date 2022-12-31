extends Node
class_name BaseItem

var raw
var current

func _init(data):
	if data is String:
		return
	raw = data.duplicate(true)
	current = raw.duplicate(true)
	current.ability = Data.get_ability(raw.ability)

func activate(host):
	current.ability.execute(host)
