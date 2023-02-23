extends Spatial

onready var name_entry = $LineEdit
onready var chat_color_picker = $LineEdit/TestChat/ColorPicker
onready var join_server_button = $LineEdit/Button
onready var test_chat_history = $LineEdit/TestChat/History
onready var test_chat_entry = $LineEdit/TestChat/Entry

func _ready():
	join_server_button.hide()
	name_entry.connect("focus_exited", self, "on_name_entry")
	name_entry.connect("text_entered", self, "on_name_entry")
	chat_color_picker.connect("popup_closed", self, "on_chat_color_picker")
	join_server_button.connect("button_down", self, "on_join_server_button")
	test_chat_entry.connect("text_entered", self, "on_test_chat_entry")
	
func on_name_entry(_words = "") -> void:
	if name_entry.text != "":
		Data.set_char_value("name", name_entry.text)
		join_server_button.show()
	else:
		join_server_button.hide()
	pass
	
func on_chat_color_picker() -> void:
	Data.set_char_value("chat_color", chat_color_picker.color.to_html())
	pass
	
func on_join_server_button() -> void:
	Client.join()
	yield(get_tree(), "connected_to_server")
	Events.emit_signal("scene_change_request", "test_room")
	pass

func on_test_chat_entry(words: String) -> void:
	test_chat_history.bbcode_text += "[color=#"+chat_color_picker.color.to_html()+"]"+words+"[/color]\n"
	test_chat_entry.clear()
