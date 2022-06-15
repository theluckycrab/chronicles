extends Reference
class_name ReferenceList

var item_list = {}
var ref_list = {}
var mesh_list = {}
var attack_list = {}
var projectile_list = {}


func get_data(what):
	return ref_list[what]
	
	
func get_instance(what):
	return ref_list[what].duplicate()
	
	
func setup() -> void:
	build_list("res://data/items", ".tres", item_list)
	build_list("res://data", ".tres", ref_list)
	build_list("res://data/assets/meshes", ".mesh", mesh_list)
	#build_list("res://data/attacks", ".tres", attack_list)
	build_list("res://data/projectiles", ".tscn", projectile_list)
	ref_list["player"] = "res://world/objects/mobiles/player/player.tscn"
	ref_list["base_mobile"] = "res://world/objects/mobiles/base_mobile/base_mobile.tscn"
	ref_list["item_cube"] = "res://world/objects/generic/item_cube.tscn"
	ref_list["target_dummy"] = "res://world/objects/mobiles/target_dummy/target_dummy.tscn"
	
	
func build_list(path, ending = ".tres", list = ref_list) -> void:
	#print("Data.reference reading ", path, " for ", ending)
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		if file.ends_with(ending):
			load_data(path, file, list)
		if dir.current_is_dir() and file != "." and file != "..":
			build_list(path+"/"+file, ending, list)
	dir.list_dir_end()
	
	
func load_data(path:String, file:String, list:Dictionary) -> void:
	var object = load(path+"/"+file)
	list[file.get_basename()] = object
#	print("Data.reference storing ", file)


func convert_paths_to_objects(list) -> void:
	for i in list:
		var object = load(list[i])
		list[i] = object
		
		
func get_projectile(index: String) -> PackedScene:
	return projectile_list[index]
