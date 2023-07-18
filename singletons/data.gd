extends Node

var client_version = ""

var abilities: Dictionary = {}
var items: Dictionary = {}
var mobiles: Dictionary = {}
var buffs: Dictionary = {}
var config: Dictionary = {
		"invert_x":false, 
		"invert_y":false,
		"h_sens":0.5,
		"v_sens":0.5, 
		"fullscreen":false,
		"last_character":"new_character",
		"client_version":get_client_version()
			}
var new_char_data: Dictionary = {
		"name":"New Character", 
		"equipment":["naked_chest", "naked_legs", "naked_head", "naked_gloves",\
				"naked_boots", "naked_mainhand", "naked_offhand"], 
		"chat_color":"ffef01", 
		"last_map":"test_room"}
var char_data: Dictionary = new_char_data
signal config_changed

func _init() -> void:
	validate_installation()
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
		var parse = JSON.parse(f.get_as_text())
		if parse.error_string != "":
			print(parse.error_string)
			f.close()
			return parse.error_string
		list = parse.result
		f.close()
	if path == "res://data/json/":
		for i in list:
			list[i]["index"] = i
			if i != "base":
				for field in list.base:
					if ! list[i].has(field):
						list[i][field] = list.base[field]
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
	for i in new_char_data:
		if ! char_data.has(i):
			char_data[i] = new_char_data[i]
	Events.emit_signal("char_data_changed")
		
func load_config() -> void:
	var f = File.new()
	if f.file_exists("user://config"):
		var inc = load_from_file("config", "user://", "")
		if inc is String:
			print(inc)
			save_config()
			return
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
	else:
		print("Config does not contain ", key)

func save_char() -> void:
	set_char_value("client_version", get_client_version())
	var f = File.new()
	var d = get_char_data()
	f.open("user://saves/"+get_snake_case(d.name), File.WRITE)
	f.store_string(JSON.print(d))
	f.close()
	
func delete_char_save(n):
	var dir = Directory.new()
	dir.remove("user://saves/"+Data.get_snake_case(Data.get_char_data().name))
	
func save_config() -> void:
	set_config_value("client_version", get_client_version())
	var f = File.new()
	var d = config.duplicate(true)
	f.open("user://"+"config", File.WRITE)
	f.store_string(JSON.print(d))
	f.close()
	emit_signal("config_changed")

func _exit_tree():
	set_config_value("last_character", get_char_value("name"))
	save_config()
	save_char()

func load_client_version():
	var f = File.new()
	f.open("res://data/json/shared_config.json", File.READ)
	var sc = JSON.parse(f.get_as_text()).result
	f.close()
	if ! sc.has("client_version"):
		return false
	else:
		client_version = sc.client_version
		return true
	
func get_client_version():
	return client_version
	
func get_saved_character(n):
	var f = File.new()
	var char_data = {}
	f.open("user://saves/"+get_snake_case(n), File.READ)
	char_data = JSON.parse(f.get_as_text()).result
	f.close()
	return char_data
	
func get_all_saves():
	var dir = Directory.new()
	var characters = {}
	dir.open("user://saves/")
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name != "." and file_name != ".." and file_name != "new_character" and file_name != "null_edgelord,_grand_orator_of_testers":
			characters[file_name] = get_saved_character(file_name)
		file_name = dir.get_next()
	dir.list_dir_end()
	return characters
	
func validate_installation():
	var d = Directory.new()
	var f = File.new()
	if ! load_client_version():
		OS.alert("No version info?", "Chronicles of Delonda")
	if ! d.dir_exists("user://saves/"):
		d.make_dir("user://saves/")
	if ! f.file_exists("user://saves/new_character"):
		save_char()
	if ! f.file_exists("user://config"):
		save_config()
