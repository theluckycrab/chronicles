extends Control

var next_scene: String = "test_room"

onready var button_offline = $VBoxContainer/Offline
onready var button_online = $VBoxContainer/Online
onready var button_defaults = $VBoxContainer/Defaults
onready var join_button = $VBoxContainer/Online/VBoxContainer/Join
onready var host_button = $VBoxContainer/Online/VBoxContainer/Host
onready var join_host_panel = $VBoxContainer/Online/VBoxContainer
onready var defaults_menu = $DefaultsMenu
onready var line_edit = $VBoxContainer/LineEdit


func _ready() -> void:
	button_offline.connect("button_down", self, "on_offline")
	button_online.connect("button_down", self, "on_online")
	button_defaults.connect("button_down", self, "on_defaults")
	join_button.connect("button_down", self, "on_join")
	host_button.connect("button_down", self, "on_host")
	defaults_menu.connect("hide", self, "on_defaults_hide")
	
	Network.peer.connect("connection_succeeded", self, "on_next")
	line_edit.text = Data.get_config_value("last_character")
	Data.set_char_value("alias", Data.get_config_value("last_character"))
	line_edit.connect("text_changed", self, "on_alias_changed")
	
	
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
	Data.set_char_value("alias", $VBoxContainer/LineEdit.text)
	Data.load_char_save($VBoxContainer/LineEdit.text)
	Data.save_config_value("last_character", $VBoxContainer/LineEdit.text)
	next_scene = Data.get_saved_char_value("map")
	Network.set_nid()
	Events.emit_signal("console_print", "Your network ID is : " + str(Network.get_nid()))
	Events.emit_signal("scene_change_request", next_scene)
	
	
func on_defaults():
	$VBoxContainer.visible = false
	$DefaultsMenu.visible = true


func on_defaults_hide():
	$VBoxContainer.visible = true
	$DefaultsMenu.visible = false
	Data.load_char_save(Data.get_char_value("alias"))
	$VBoxContainer/LineEdit.text = Data.get_char_value("alias")


func on_alias_changed(text):
	Data.set_char_value("alias", text)
