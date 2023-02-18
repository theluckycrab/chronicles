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
var config: Dictionary = {
		"invert_x":1, 
		"invert_y":-1, 
		"fullscreen":false,
		"last_character":"new_character",
			}
var char_data: Dictionary = {"name":"New Character", "equipment":["base_human_body"], "chat_color":"lime"}

func _init() -> void:
	init_lists()
	OS.window_fullscreen = get_config_value("fullscreen")

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
	abilities = load_from_file("abilities")
	items = load_from_file("items")
	mobiles = load_from_file("mobiles")
	load_config()
	load_char_data(get_config_value("last_character"))

func load_from_file(file_name: String, path: String = "res://data/json/", extension: String = ".json") -> Dictionary:
	var f = File.new()
	var list = {}
	if f.file_exists(path + file_name + extension):
		f.open(path+file_name+extension, File.READ)
		list = JSON.parse(f.get_as_text()).result
		f.close()
	return list

func get_char_data() -> Dictionary:
	return char_data.duplicate(true)
	
func get_char_value(key: String):
	if char_data.has(key):
		return char_data[key]
	else:
		return "Char data does not contain " + key
	
func load_char_data(c: String) -> void:
	var f = File.new()
	if f.file_exists("user://saves/"+c):
		char_data = load_from_file(c, "user://saves/", "")
	else:
		print(c + " not found in the saves folder.")
		
func load_config() -> void:
	var f = File.new()
	if f.file_exists("user://config"):
		var inc = load_from_file("config", "user://", "")
		for i in config:
			if inc.has(i):
				config[i] = inc[i]
	
func get_config_value(key: String): 
	if config.has(key):
		return config[key]
	else:
		return "Config data does not contain " + key

func get_snake_case(s: String) -> String:
	s = s.dedent()
	s = s.to_lower()
	s = s.replace(" ", "_")
	return s
	
func set_char_value(key: String, value) -> void:
	if char_data.has(key):
		char_data[key] = value
	Events.emit_signal("char_data_changed", key, value)
		
func set_config_value(key: String, value) -> void:
	if config.has(key):
		config[key] = value

func save_char() -> void:
	var f = File.new()
	var d = get_char_data()
	f.open("user://saves/"+get_snake_case(d.name), File.WRITE)
	f.store_string(JSON.print(d))
	f.close()
	
func save_config() -> void:
	var f = File.new()
	var d = config.duplicate(true)
	f.open("user://"+"config", File.WRITE)
	f.store_string(JSON.print(d))
	f.close()

func _exit_tree():
	set_config_value("last_character", get_snake_case(get_char_value("name")))
	save_config()
	save_char()
