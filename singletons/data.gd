extends Node

var abilities: Dictionary = {}
var items: Dictionary = {}
var mobiles: Dictionary = {}
var buffs: Dictionary = {}
var config: Dictionary = {
		"invert_x":1, 
		"invert_y":-1, 
		"fullscreen":false,
		"last_character":"new_character",
			}
var new_char_data: Dictionary = {"name":"New Character", "equipment":["base_human_body"], "chat_color":"ffef01"}
var char_data: Dictionary = new_char_data

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
	
func get_buff(index: String) -> BaseBuff:
	var buff = buffs[index].duplicate(true)
	return BaseBuff.new(buff)

func init_lists() -> void:
	abilities = load_from_file("abilities")
	items = load_from_file("items")
	mobiles = load_from_file("mobiles")
	buffs = load_from_file("buffs")
	load_config()
	load_char_data(get_config_value("last_character"))

func load_from_file(file_name: String, path: String = "res://data/json/", extension: String = ".json") -> Dictionary:
	var f = File.new()
	var list = {}
	if f.file_exists(path + file_name + extension):
		f.open(path+file_name+extension, File.READ)
		list = JSON.parse(f.get_as_text()).result
		f.close()
	if path == "res://data/json/":
		for i in list:
			list[i]["index"] = i
	return list

func get_char_data() -> Dictionary:
	return char_data.duplicate(true)
	
func get_char_value(key: String):
	if char_data.has(key):
		return char_data[key]
	else:
		return "Char data does not contain " + key
	
func load_char_data(c: String) -> void:
	c = get_snake_case(c)
	var f = File.new()
	if f.file_exists("user://saves/"+c):
		char_data = load_from_file(c, "user://saves/", "")
	else:
		char_data = new_char_data
		print(c + " not found in the saves folder.")
	var player = get_mobile_data("player")
	for i in player["equipment"]:
		var will_equip = true
		var p_item = items[i]
		for e in char_data.equipment:
			if p_item.slot == items[e].slot:
				will_equip = false
				break
		if will_equip:
			char_data.equipment.append(i)
	Events.emit_signal("char_data_changed")
		
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
	Events.emit_signal("char_data_changed")
		
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
	set_config_value("last_character", get_char_value("name"))
	save_config()
	save_char()
