extends Control

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
	
	
func on_offline() -> void:
	Network.host(1)
	Events.emit_signal("scene_change_request", "test_room")
	
	
func on_online() -> void:
	join_host_panel.visible = !join_host_panel.visible
	
	
func on_join() -> void:
	Network.join()
	Events.emit_signal("scene_change_request", "test_room")
	
	
func on_host() -> void:
	Network.host(4)
	Events.emit_signal("scene_change_request", "test_room")
	
	
func on_test() -> void:
	Events.emit_signal("scene_change_request", "test_room")
