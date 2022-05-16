extends Reference
class_name ReferenceList

var list = {}


func get_data(what):
	return list[what]
	
	
func get_instance(what):
	return list[what].duplicate()
	
	
func build_list(path) -> void:
	print("building reference database")
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		if file.ends_with(".tres"):
			load_data(path, file)
		if dir.current_is_dir() and file != "." and file != "..":
			build_list(path+"/"+file)
	dir.list_dir_end()
	list["player"] = "res://world/objects/mobiles/player/player.tscn"
	list["item_cube"] = "res://world/objects/generic/item_cube.tscn"

	
func load_data(path:String, file:String) -> void:
	var object = load(path+"/"+file)
	list[file.get_basename()] = object
