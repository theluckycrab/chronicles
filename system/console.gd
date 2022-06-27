extends Control

onready var history = $VBoxContainer/TextEdit
onready var entry = $VBoxContainer/LineEdit
var chat_mode = false


func _ready() -> void:
	var _discard = entry.connect("text_entered", self, "on_entry")
	var _dicksard = history.connect("text_changed", self, "on_history")
	var _dicksword = Events.connect("console_print", self, "on_console_print")
	var _deez = Events.connect("net_print", self, "on_net_print")
	$VBoxContainer/LineEdit.modulate = Color(Data.get_config_value("chat_color"))
	
func _input(event) -> void:
	if event.as_text() == "QuoteLeft" and event.is_pressed() and !event.is_echo():
		chat_mode = true
	elif event.as_text() == "Enter" and event.is_pressed() and !event.is_echo() and ! visible:
		chat_mode = false
		
	if (event.as_text() == "QuoteLeft") or (event.as_text() == "Enter"):
		if event.is_pressed() and !event.is_echo():
			if !visible:
				entry.grab_focus()
				entry.text = ""
				show()
			else:
				if event.as_text() == "QuoteLeft":
					hide()
				else:
					return
			get_tree().set_input_as_handled()
	
func on_entry(text) -> void:
	net_send(text)
	entry.text = ""
	if !chat_mode:
		hide()
	
	
func on_history() -> void:
	history.scroll_vertical = 600000
	

func on_console_print(text: String) -> void:
	text = text.dedent()
	if text != "":
		if "/" in text:
			command_dispatch(text)
			return
		history.text += text + "\n"
		history.emit_signal("text_changed")
		
func on_net_print(args):
	Events.emit_signal("console_print", args.text)
		
	
func net_send(text):
	if "/" in text:
		on_console_print(text)
		return
	text = text.lstrip("/")
	text = Network.alias + ": "+ text
	Network.relay_signal("net_print",{text = text, sender=Network.get_nid(), color=Data.get_config_value("chat_color")})
		
		
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
		"set_alias":
			set_alias(text)


func get_command_format(text) -> PoolStringArray:
	text = text.lstrip("/")
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
	yield(get_tree().create_timer(0.005), "timeout")
	on_history()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	#get_viewport().warp_mouse(Vector2(0,0))
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	
func hide():
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func set_alias(a):
	a = a.join(" ")
	a = a.lstrip("/set_alias")
	Network.alias = a
