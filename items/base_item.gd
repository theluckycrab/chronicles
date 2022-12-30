extends Node
class_name BaseItem

var raw
var current

func _init(index):
	raw = Data.get_item(index)
	current = raw
	current.ability = BaseAbility.new(raw.ability)
	current.mesh = load("res://blender/equipment/"+raw.mesh+".mesh")

func activate(host):
	current.ability.execute(host)
