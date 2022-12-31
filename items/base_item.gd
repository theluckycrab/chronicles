extends Node
class_name BaseItem

var raw
var current

func _init(data):
	raw = data
	current = raw
	current.ability = Data.get_ability(raw.ability)

func activate(host):
	current.ability.execute(host)
