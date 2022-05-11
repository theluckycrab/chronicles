extends Node
class_name ReferenceList

var list = {}

func get_data(_what):
	pass
	
func build_list(path):
	print("building references to " + path)
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		if file.ends_with(".tres"):
			store_data(file)
		if file is Directory:
			print(file)
	dir.list_dir_end()

	
func store_data(file):
	print(file)
