class_name Persistence
extends Node

const save_path = "user://saves/"

var file_data = {
	alias = "Player",
	map = "main_menu",
	defaults = {}
}

func _init():
	#file_data.alias = "Donger"
	#commit_to_file("crabb")
	#load_from_file("crab")
	pass
	
func _ready():
	pass
	
func save_value(key, value):
	file_data[key] = value
	pass
	
func get_saved_value(key):
	return file_data[key]
	
func get_full_saved_data():
	pass

func commit_to_file(file_name):
	var file = File.new()
	file.open(save_path+file_name+".chron", File.WRITE)
	file.store_string(to_json(file_data))
	file.close()
	pass
	
func load_from_file(file_name):
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

