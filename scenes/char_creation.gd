extends Spatial

onready var name_entry = $LineEdit
onready var chat_color_picker = $LineEdit/TestChat/ColorPicker
onready var join_server_button = $LineEdit/Button
onready var test_chat_history = $LineEdit/TestChat/History
onready var test_chat_entry = $LineEdit/TestChat/Entry
onready var armature = $Armature

func _ready():
	name_entry.connect("focus_exited", self, "on_name_entry")
	name_entry.connect("text_entered", self, "on_name_entry")
	chat_color_picker.connect("popup_closed", self, "on_chat_color_picker")
	join_server_button.connect("button_down", self, "on_join_server_button")
	test_chat_entry.connect("text_entered", self, "on_test_chat_entry")
	name_entry.text = Data.get_config_value("last_character")
	chat_color_picker.color = Data.get_char_value("chat_color")
	build_outfit()
	var _discard = Events.connect("char_data_changed", self, "on_char_data_changed")
	
func on_name_entry(_words = "") -> void:
	if name_entry.text == "" or "[" in name_entry.text:
		name_entry.text = "Null Edgelord, Grand Orator of Testers"
	Data.set_char_value("name", name_entry.text)
	Data.load_char_data(name_entry.text)
	build_outfit()
	pass
	
func on_chat_color_picker() -> void:
	Data.set_char_value("chat_color", chat_color_picker.color.to_html())
	Data.save_char()
	pass
	
func on_join_server_button() -> void:
	if name_entry.text == "":
		name_entry.text = "Null Edgelord, Grand Orator of Testers"
	Data.load_char_data(name_entry.text)
	Client.join()
	yield(get_tree(), "connected_to_server")
	Events.emit_signal("scene_change_request", "test_room")
	pass

func on_test_chat_entry(words: String) -> void:
	test_chat_history.bbcode_text += "[color=#"+chat_color_picker.color.to_html()+"]"+words+"[/color]\n"
	test_chat_entry.clear()

func on_char_data_changed() -> void:
	chat_color_picker.color = Data.get_char_value("chat_color")
	
func build_outfit() -> void:
	for i in armature.equipped_items:
		armature.unequip(i)
	var list = Data.get_char_data()
	for i in list.equipment:
		armature.equip(Data.get_item(i))
