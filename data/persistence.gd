class_name Persistence
extends Node

const save_path = "user://saves/"

var char_data = {
	alias = "New Character",
	map = "lobi_town",
	defaults = {},
	equipped = {},
	inventory = [],
	pouch = []
}

var config = {
	last_character = "New Character",
	chat_color = "ffffff",
	system_color = "ff1357a6",
	last_server = "127.0.0.1",
	version = "0.0.0"
}

var base_config = config.duplicate(true)

func setup():
	load_config_from_file()
	
	
#Character Save File Interface
func load_char_from_file(file_name):
	file_name = Data.snake_case(file_name)
	var file = File.new()
	if file.file_exists(save_path+file_name+".chron"):
		file.open_encrypted_with_pass(save_path+file_name+".chron", File.READ, "dongers")
		#var data = parse_json(file.get_as_text())
		var data = file.get_var(true)
		file.close()
		if data is Dictionary:
			for i in char_data:
				if data.has(i):
					char_data[i] = data[i]
		else:
			print("data corrupted")
	else:
		print("/////\n Attempt to load ", save_path+file_name+".chron", " has failed!", "//////\n")


func commit_to_char_file():
	var file_name = Data.snake_case(char_data.alias)
	var file = File.new()
	file.open_encrypted_with_pass(save_path+file_name+".chron", File.WRITE, "dongers")
	file.store_var(char_data)
	#file.store_string(to_json(char_data))
	file.close()
	pass


func set_char_value(key, value):
	match key:
		"default":
			char_data["defaults"][value.slot] = value.index
		"equipped":
			if value.has_tag("Default"):
				char_data["equipped"].erase(value.slot)
				return
			char_data["equipped"][value.slot] = value.index
		"inventory":
			char_data["inventory"].append(value.index)
		"pouch":
			char_data["pouch"].append(value.index)
		_:
			char_data[key] = value


func save_char_value(key, value):
	set_char_value(key, value)
	commit_to_char_file()
	pass
	
	
func remove_char_value(key, value):
	if !char_data.has(key):
		return
	match key:
		"inventory":
			char_data["inventory"].erase(value.index)
		"pouch":
			char_data["pouch"].erase(value.index)
	
	
func get_saved_char_value(key):
	return char_data[key]
	
	
func get_char_value(key):
	return char_data[key]
	
	
func get_char_data():
	return char_data
	
#Config File Interface
func load_config_from_file():
	var file_name = "config"
	var file = File.new()
	if file.file_exists(save_path+file_name):
		file.open_encrypted_with_pass(save_path+file_name, File.READ, "dongers")
		var data = file.get_var(true)
		#var data = parse_json(file.get_as_text())
		file.close()
		if data is Dictionary:
			config = data.duplicate(true)
		else:
			print("data corrupted")
	else:
		print("/////\n Attempt to load ", save_path+file_name, " has failed!", "//////\n")


func commit_to_config_file():
	var file_name = Data.snake_case("config")
	var file = File.new()
	file.open_encrypted_with_pass(save_path+file_name, File.WRITE, "dongers")
	file.store_var(config)
	#file.store_string(to_json(config))
	file.close()
	pass


func get_config(key):
	if config.has(key):
		return config[key]
	else:
		config[key] = base_config[key]
		return base_config[key]
	
	
func save_config(key, value):
	config[key] = value
	commit_to_config_file()
