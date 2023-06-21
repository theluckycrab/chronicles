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
onready var name_edit_button = $Control/NameEditButton
onready var delete_button = $Control/VBoxContainer/DeleteButton
onready var new_button = $Control/VBoxContainer/NewCharacterButton
onready var name_entry_form = $Control/NameEntryForm
onready var name_entry = $Control/NameEntryForm/NameEntry
onready var name_entry_form_color = $Control/NameEntryForm/ColorPickerButton

func _ready():
	generate_nameplates()
	on_char_button(Data.get_config_value("last_character"))
	join_button.connect("button_down", self, "on_join")
	back_button.connect("button_down", self, "on_back")
	delete_button.connect("button_down", self, "on_delete")
	new_button.connect("button_down", self, "on_new")
	name_edit_button.connect("button_down", self, "on_name_edit")
	name_entry.connect("text_entered", self, "on_name_entry")

func generate_nameplates():
	for i in name_list.get_children():
		i.queue_free()
	characters.clear()
	var dir = Directory.new()
	dir.open("user://saves/")
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name != "." and file_name != ".." and file_name != "new_character" and file_name != "null_edgelord,_grand_orator_of_testers":
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
	generate_item_list()
	
	
func generate_item_list():
	preview_model.animator.get_animation("Idle").loop = true
	preview_model.play("Idle")
	for i in char_data.equipment:
		var item = Data.get_item(i)
		preview_model.equip(item)
		if item.current.name != "None":
			var l = item_label.instance()
			l.set_text(Data.get_item(i).current.name)
			item_list.add_child(l)
	name_edit_button.set_text(char_data.name)
	name_edit_button.label.add_color_override("font_color", char_data.chat_color)
		
func on_join() -> void:
	Client.join()
	yield(get_tree(), "connected_to_server")
	Simulation.switch_scene(Data.get_char_value("last_map"))
	
func on_back():
	Simulation.switch_scene("main_menu")

func on_delete():
	var dir = Directory.new()
	dir.remove("user://saves/"+Data.get_snake_case(Data.get_char_data().name))
	if characters.empty():
		on_char_button("new_character")
	else:
		on_char_button(characters.front())
	generate_nameplates()
	
func on_new():
	on_char_button("new_character")

func on_name_edit():
	name_entry_form.show()
	name_entry.grab_focus()
	name_entry.text = char_data.name
	
func on_name_entry(n):
	name_entry_form.hide()
	name_edit_button.set_text(n)
	Data.set_char_value("name", n)
	Data.set_char_value("chat_color", name_entry_form_color.color.to_html())
	Data.save_char()
	generate_nameplates()
	on_char_button(n)
