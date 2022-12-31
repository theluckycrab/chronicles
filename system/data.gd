extends Node

var effects = {}
var abilities = {} #primitive -> complex, order matters
var items = {}



func _init():
	init_lists()
	
func init_lists():
	effects = load_json("effects")
	abilities = load_json("abilities")
	items = load_json("items")

func load_json(file_name):
	var f = File.new()
	var list = {}
	f.open("res://data/"+file_name+".json", File.READ)
	list = JSON.parse(f.get_as_text()).result
	f.close()
	return list

func get_item(index, args={}):
	var item = items[index].duplicate(true)
	return BaseItem.new(item)
	
func get_ability(index, args={}):
	var ability = abilities[index].duplicate(true)
	match ability.type:
		"buff":
			return BaseAbility.new(ability)
	return null
	
func get_effect(index, args={}):
	var effect = effects[index].duplicate(true)
	match effect.type:
		"equip":
			return EquipEffect.new(effect, args)
	return null
