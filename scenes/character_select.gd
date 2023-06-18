extends Spatial

var char_label = preload("res://ui/labeled_button.tscn")
var item_label = preload("res://ui/labeled_button.tscn")

var characters = []
var char_data = {}
onready var join_button = $Control/HBoxContainer2/JoinButton
onready var back_button = $Control/HBoxContainer2/BackButton
onready var name_list = $Control/HBoxContainer/NameList
onready var item_list = $Control/HBoxContainer3/ItemList
onready var preview_model = $Armature
onready var current_char_name_label = $Control/CurrentCharName/Label

func _ready():
	generate_nameplates()
	on_char_button(Data.get_config_value("last_character"))
	join_button.connect("button_down", self, "on_join")
	back_button.connect("button_down", self, "on_back")

func generate_nameplates():
	for i in name_list.get_children():
		i.queue_free()
	var dir = Directory.new()
	var file = File.new()
	dir.open("user://saves/")
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name != "." and file_name != "..":
			characters.append(file_name)
		file_name = dir.get_next()
	dir.list_dir_end()
	for i in characters:
		var l = char_label.instance()
		l.set_text(i)
		name_list.add_child(l)
		l.connect("button_down", self, "on_char_button", [i])
		
func on_char_button(n):
	preview_model.reset_equipment()
	for i in item_list.get_children():
		i.queue_free()
	Data.load_char_data(n)
	char_data = Data.get_char_data()
	for i in char_data.equipment:
		var item = Data.get_item(i)
		preview_model.equip(item)
		if item.current.name != "None":
			var l = item_label.instance()
			l.set_text(Data.get_item(i).current.name)
			item_list.add_child(l)
	current_char_name_label.set_text(char_data.name)
	current_char_name_label.add_color_override("font_color", char_data.chat_color)
		
func on_join() -> void:
	Client.join()
	yield(get_tree(), "connected_to_server")
	Events.emit_signal("scene_change_request", "test_room")
	
func on_back():
	Events.emit_signal("scene_change_request", "main_menu")
