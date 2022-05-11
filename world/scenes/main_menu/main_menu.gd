extends Control

onready var button_offline = $VBoxContainer/Offline
onready var button_online = $VBoxContainer/Online
onready var button_test = $VBoxContainer/Test


func _ready() -> void:
	button_offline.connect("button_down", self, "on_offline")
	button_online.connect("button_down", self, "on_online")
	button_test.connect("button_down", self, "on_test")
	
	
func on_offline() -> void:
	Events.emit_signal("scene_change_request", "test_room")
	
	
func on_online() -> void:
	Events.emit_signal("scene_change_request", "test_room")
	
	
func on_test() -> void:
	Events.emit_signal("scene_change_request", "test_room")
