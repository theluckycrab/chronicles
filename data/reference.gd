extends Reference
class_name ReferenceList

var item_list = {}
var ref_list = {}
var mesh_list = {}
var ability_list = {}
var projectile_list = {}
var scene_list = {}


func get_data(what):
	return ref_list[what]
	
	
func get_instance(what):
	return ref_list[what].duplicate()
	
	
func setup() -> void:
	build_list("res://data/assets/meshes", ".mesh", mesh_list)
	build_list("res://data/projectiles", ".tscn", projectile_list)
	build_list("res://data/abilities/", ".gd", ability_list)
	#build_list("res://data/items", ".tres", item_list)
	#build_list("res://data", ".tres", ref_list)
	build_list("res://world/scenes", ".tscn", scene_list)

	ref_list["player"] = "res://world/mobiles/player/player.tscn"
	ref_list["base_mobile"] = "res://world/mobiles/base_mobile/base_mobile.tscn"
	ref_list["item_cube"] = "res://world/objects/generic/item_cube.tscn"
	ref_list["target_dummy"] = "res://world/mobiles/target_dummy/target_dummy.tscn"
	ref_list["loot_barrel"] = "res://world/objects/interactable/loot_barrel/loot_barrel.tscn"
	ref_list["throwing_knife_projectile"] = "res://data/projectiles/throwing_knife/throwing_knife.tscn"
	ref_list["melee_aux"] = "res://data/projectiles/melee_aux/melee_aux.tscn"
	ref_list["projectile"] = "res://data/projectiles/melee_aux/melee_aux/tscn"
	ref_list["spawner"] = "res://world/objects/generic/spawners/spawner.tscn"
	ref_list["debug"] = "res://world/mobiles/debug_mobile/debug_mobile.tscn"
	
	load_item_database()
	
func build_list(path, ending = ".tres", list = ref_list) -> void:
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


func convert_paths_to_objects(list) -> void:
	for i in list:
		var object = load(list[i])
		list[i] = object
		
		
func get_projectile(index: String) -> PackedScene:
	return projectile_list[index]


func load_item_database():
	var file = File.new()
	file.open("res://data/spreadsheets/item_database.csv", File.READ)
	var headers = file.get_csv_line()
	var jobject = {}
	for i in headers:
		jobject[i] = i
	while ! file.eof_reached():
		var line = file.get_csv_line()
		var nobject = jobject.duplicate(true)
		var counter = 0
		if line.size() > 1:
			for i in line:
				if i.is_valid_integer():
					i = i as int
				nobject[nobject.keys()[counter]] = i
				counter += 1
			item_list[nobject.index] = nobject.duplicate(true)
	print(item_list)
	file.close()
