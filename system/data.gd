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

func get_item(index):
	if index == "":
		return index
	return items[index].duplicate(true)
	
func get_ability(index):
	if index == "":
		return index
	return abilities[index].duplicate(true)
	
func get_effect(index):
	if index == "":
		return index
	return effects[index].duplicate(true)
