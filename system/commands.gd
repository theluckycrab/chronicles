extends Node

var command_list = {}

func _ready():
	build_command_list("res://system/bin")
	print(command_list)

func build_command_list(path):
	var dir = Directory.new()
	dir.open("res://system/bin/")
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		if file.ends_with(".gd"):
			command_list[file.get_basename()] = load("res://system/bin/"+file).new()
		if dir.current_is_dir() and file != "." and file != "..":
			build_command_list(path+"/"+file)
	dir.list_dir_end()

func parse_text_for_commands(text):
	text = text.split(" ", false)
	if text.empty():
		return false
	if ! text[0].begins_with("/"):
		return false
	text[0] = text[0].trim_prefix("/")
	if command_list.keys().has(text[0]):
		var c = text[0]
		text.remove(0)
		command_list[c].execute(text)
		return true
