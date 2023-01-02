extends Node

var effects = {}
var abilities = {} #primitive -> complex, order matters
var items = {}
var projectiles = {}



func _init():
	init_lists()
	
func init_lists():
	abilities = load_json("abilities")
	items = load_json("items")

func load_json(file_name):
	var f = File.new()
	var list = {}
	f.open("res://data/"+file_name+".json", File.READ)
	list = JSON.parse(f.get_as_text()).result
	f.close()
	return list

func get_item(index, _args={}):
	var item = items[index].duplicate(true)
	return BaseItem.new(item)
	
func get_ability(index, _args={}):
	var ability = abilities[index].duplicate(true)
	return BaseAbility.new(ability)
