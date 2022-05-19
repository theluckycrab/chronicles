extends Control

onready var history = $VBoxContainer/TextEdit
onready var entry = $VBoxContainer/LineEdit


func _ready() -> void:
	var _discard = entry.connect("text_entered", self, "on_entry")
	var _dicksard = history.connect("text_changed", self, "on_history")
	var _dicksword = Events.connect("console_print", self, "on_console_print")
	
	
func _input(event) -> void:
	if event.as_text() == "QuoteLeft" and event.is_pressed() and !event.is_echo():
		if !visible:
			entry.grab_focus()
			entry.text = ""
			show()
		else:
			hide()
		get_tree().set_input_as_handled()
	
	
func on_entry(text) -> void:
	Events.emit_signal("console_print", text)
	entry.text = ""
	
	
func on_history() -> void:
	history.scroll_vertical = 600000
	

func on_console_print(text: String) -> void:
	text = text.dedent()
	if text != "":
		if "." in text:
			command_dispatch(text)
			return
		history.text += text + "\n"
		history.emit_signal("text_changed")
		
		
func command_dispatch(text) -> void:
	text = get_command_format(text)
	match text[0]:
		"print":
			reprint(text)
		"load":
			load_scene(text)
		"equip":
			equip(text)
		"network_host":
			Network.host()
		"network_join":
			Network.join()
		"network_disconnect":
			get_tree().network_peer.close_connection()
		"network_status":
			print(get_tree().network_peer.get_connection_status())
			print(get_tree().get_network_unique_id())
		"quit":
			get_tree().quit()


func get_command_format(text) -> PoolStringArray:
	text = text.lstrip(".")
	text = text.split(" ")
	return text


func reprint(text) -> void:
	text.remove(0)
	text = text.join(" ")
	print(text)
	Events.emit_signal("console_print", text)
	
	
func load_scene(text) -> void:
	text.remove(0)
	text = text.join(" ")
	Events.emit_signal("scene_change_request", text)
	hide()
	
	
func equip(text) -> void:
	text.remove(0)
	text = text.join(" ")
	var item = Data.items[text].duplicate()
	get_node("/root/SceneManager/SceneMount/Start/Player").equip(item)
	hide()

func show():
	visible = true
	add_to_group("menus")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func hide():
	visible = false
	remove_from_group("menus")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
