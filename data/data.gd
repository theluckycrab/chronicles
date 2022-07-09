extends Node

signal data_ready

var reference = ReferenceList.new()
var persistence = Persistence.new()


func _ready() -> void:
	randomize()
	init_files()
	persistence.setup()
	reference.setup()
	call_deferred("emit_signal", "data_ready")
	print("Data ready")


#Reference interface
func get_reference(index):
	return reference.ref_list[index]
	
	
func get_reference_instance(index):
	var object = reference.get_data(index)
	if object is Resource:
		return object.duplicate()
	elif object is String:
		return load(object).instance()
	elif object is PackedScene:
		return load(object).instance()
		

func get_mesh(index):
	return reference.mesh_list[index]


func get_item(index):
	var i
	match reference.item_list[index].slot:
		"mainhand":
			i = Weapon.new(reference.item_list[index])
		_:
			i = Item.new(reference.item_list[index])
	return i
	#return reference.item_list[index]
	
func get_random_item():
	var i = randi() % reference.item_list.size()
	var k = reference.item_list.keys()[i]
	return get_item(k)
	
func get_ability(index):
	index = snake_case(index)
	return reference.ability_list[index]
	
	
func get_projectile(index):
	return reference.get_projectile(index)


func snake_case(string) -> String:
	string = string.to_lower().replace(" ", "_")
	return string


#persistence interface
func get_saved_char_value(key):
	return persistence.get_saved_char_value(key)
	
func set_char_value(key, value):
	return persistence.set_char_value(key, value)

func get_char_value(key):
	return persistence.get_char_value(key)
	
	
func get_char_data():
	return persistence.get_char_data()


func save_char_value(key, value) -> void:
	persistence.save_char_value(key, value)
	
func remove_char_value(key, value) -> void:
	persistence.remove_char_value(key, value)
	
func full_save() -> void:
	persistence.commit_to_char_file()
	persistence.commit_to_config_file()
	yield(get_tree(), "idle_frame")
	
func full_save_char() -> void:
	persistence.commit_to_char_file()
	
func full_save_config() -> void:
	persistence.commit_to_config_file()
	
func load_char_save(character_name) -> void:
	persistence.load_char_from_file(character_name)
	
func save_config_value(key, value) -> void:
	persistence.save_config(key, value)
	
func get_config_value(key):
	return persistence.get_config(key)

func load_config():
	persistence.load_config()
	
func clear_char_inventory():
	persistence.char_data["inventory"] = []
	full_save_char()
	
func clear_char_equipped():
	persistence.char_data["equipped"] = {}
	full_save_char()
	
func init_files():
	create_saves_directory()
	check_config_file_exists()
	full_save_char()
	
func create_saves_directory():
	var dir = Directory.new()
	dir.make_dir("user://saves/")
	
func check_config_file_exists():
	var file = File.new()
	if file.file_exists("user://saves/config"):
		return
	full_save_config()
