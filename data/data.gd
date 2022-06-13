extends Node

signal data_ready

var reference = ReferenceList.new()
var persistence = Persistence.new()


func _ready() -> void:
	randomize()
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
		

func get_mesh(index):
	return reference.mesh_list[index]


func get_item(index):
	return reference.item_list[index]
	
func get_attack(index):
	index = snake_case(index)
	return reference.attack_list[index]


func snake_case(string) -> String:
	string = string.to_lower().replace(" ", "_")
	return string


#persistence interface
func get_saved_char_value(key):
	return persistence.get_saved_char_value(key)

func save_char_value(key, value) -> void:
	persistence.save_char_value(key, value)
	
func full_save() -> void:
	persistence.commit_to_char_file()
	persistence.commit_to_config_file()
	
func load_char_save(character_name) -> void:
	persistence.load_char_from_file(character_name)
	
func save_config_value(key, value) -> void:
	persistence.save_config(key, value)
	
func get_config_value(key):
	return persistence.get_config(key)

func load_config():
	persistence.load_config()
