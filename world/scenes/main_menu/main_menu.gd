extends Control

var next_scene: String = "test_room"

onready var button_offline = $VBoxContainer/Offline
onready var button_online = $VBoxContainer/Online
onready var button_test = $VBoxContainer/Test
onready var join_button = $VBoxContainer/Online/VBoxContainer/Join
onready var host_button = $VBoxContainer/Online/VBoxContainer/Host
onready var join_host_panel = $VBoxContainer/Online/VBoxContainer


func _ready() -> void:
	button_offline.connect("button_down", self, "on_offline")
	button_online.connect("button_down", self, "on_online")
	button_test.connect("button_down", self, "on_test")
	join_button.connect("button_down", self, "on_join")
	host_button.connect("button_down", self, "on_host")
	
	Network.peer.connect("connection_succeeded", self, "on_next")
	$LineEdit.text = Data.get_config_value("last_character")
	
	
func _input(event) -> void:
	if event.as_text() == "QuoteLeft":
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	
func on_offline() -> void:
	Network.host(1)
	on_next()
	
	
func on_online() -> void:
	join_host_panel.visible = !join_host_panel.visible
	
	
func on_join() -> void:
	Network.join()
	
	
func on_host() -> void:
	Network.host(4)
	on_next()
	
	
func on_next() -> void:
	Data.set_char_value("alias", $LineEdit.text)
	Data.load_char_save($LineEdit.text)
	Data.save_config_value("last_character", $LineEdit.text)
	next_scene = Data.get_saved_char_value("map")
	Network.set_nid()
	Events.emit_signal("console_print", str(Network.get_nid()))
	Events.emit_signal("scene_change_request", next_scene)
