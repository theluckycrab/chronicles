class_name Persistence
extends Node

const save_path = "user://saves/"

var file_data = {
	alias = "Player",
	map = "test_room",
	defaults = {}
}

func _init():
	pass
	
func _ready():
	pass
	
func save_value(key, value):
	match key:
		"default":
			file_data["defaults"][value.slot] = value.index
			#print("defaults")
		_:
			file_data[key] = value
			#print("all")
	commit_to_file(file_data.alias)
	pass
	
func get_saved_value(key):
	return file_data[key]
	
func get_full_saved_data():
	pass

func commit_to_file(file_name):
	file_name = Data.snake_case(file_name)
	var file = File.new()
	file.open(save_path+file_name+".chron", File.WRITE)
	file.store_string(to_json(file_data))
	file.close()
	pass
	
func load_from_file(file_name):
	file_name = Data.snake_case(file_name)
	var file = File.new()
	if file.file_exists(save_path+file_name+".chron"):
		file.open(save_path+file_name+".chron", File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if data is Dictionary:
			file_data = data.duplicate(true)
		else:
			print("data corrupted")
	else:
		print("/////\n Attempt to load ", save_path+file_name+".chron", " has failed!", "//////\n")

