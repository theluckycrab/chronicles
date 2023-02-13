extends Node

"""
	Data is responsible for reading and dispatching static data in the res://data/ folders. In the
		most basic usage, json files are read as dictionaries into lists held by Data. No actual
		assets should live in these dictionaries and their size should remain as small as possible,
		as they are held in memory during the entire lifetime of the program. 
		
	Usage : When a user needs an instance of something created from these dictionaries, they will 
		call Data.get_item(index). This function will need to be minimally aware of the types of 
		items that may exist. It will be responsible for dispatching the dictionary data entry from 
		this singleton into the constructor of the appropriate item type. If the item is a weapon, 
		it may call BaseWeapon.new(data.items[index]) instead of BaseItem.new(data.items[index]).
		
		Currently, I haven't found a way to utilize a constructor on a tscn. As a result, BaseMobile
		has a build_from_data() function that takes a Dictionary. The way mobiles data is accessed
		is likely to change in the future.  
	
	Dependencies : BaseItem, BaseAbility
	Setup : The correct folder path must be set. A dictionary for each json file being loaded should
		be created. A call to load_json("filename") for each list should be added to init_lists(). 
		A get_item(index) style function needs to be made for each list.
"""

var abilities: Dictionary = {}
var items: Dictionary = {}
var mobiles: Dictionary = {}

func _init() -> void:
	init_lists()

func get_ability(index: String) -> BaseAbility:
	var ability = abilities[index].duplicate(true)
	return BaseAbility.new(ability)
	
func get_mobile_data(index: String) -> Dictionary:
	var mobile = mobiles[index].duplicate(true)
	return mobile

func get_item(index: String) -> BaseItem:
	var item = items[index].duplicate(true)
	return BaseItem.new(item)

func init_lists() -> void:
	abilities = load_json("abilities")
	items = load_json("items")
	mobiles = load_json("mobiles")

func load_json(file_name: String) -> Dictionary:
	var f = File.new()
	var list = {}
	f.open("res://data/json/"+file_name+".json", File.READ)
	list = JSON.parse(f.get_as_text()).result
	f.close()
	return list


