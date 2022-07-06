extends Control

onready var button_offline = $VBoxContainer/Offline
onready var button_online = $VBoxContainer/Online
onready var button_defaults = $VBoxContainer/Defaults
onready var join_button = $VBoxContainer/Online/VBoxContainer/Join
onready var host_button = $VBoxContainer/Online/VBoxContainer/Host
onready var join_host_panel = $VBoxContainer/Online/VBoxContainer
onready var defaults_menu = $DefaultsMenu
onready var character_name = $VBoxContainer/CharacterName
onready var server_ip = $VBoxContainer/ServerIP

onready var cam = $MeshInstance/Camera
onready var cam_start = $MeshInstance/CamStart
onready var cam_end = $MeshInstance/CamEnd


func _ready() -> void:
	cam.global_transform = cam_start.global_transform
	button_offline.connect("button_down", self, "on_offline")
	button_online.connect("button_down", self, "on_online")
	button_defaults.connect("button_down", self, "on_defaults")
	join_button.connect("button_down", self, "on_join")
	host_button.connect("button_down", self, "on_host")
	defaults_menu.connect("hide", self, "on_defaults_hide")
	
	Network.peer.connect("connection_succeeded", self, "on_next")
	character_name.text = Data.get_config_value("last_character")
	server_ip.text = Data.get_config_value("last_server")
	Data.set_char_value("alias", Data.get_config_value("last_character"))
	Data.load_char_save(Data.get_config_value("last_character"))
	character_name.connect("text_changed", self, "on_alias_changed")
	build_armature()
	print("main")
	
	
func _physics_process(_delta):
	cam.global_transform = cam.global_transform.interpolate_with(cam_end.global_transform, 0.01)
	
	
func _input(event) -> void:
	if event.as_text() == "QuoteLeft":
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	
func on_offline() -> void:
	Network.host(1)
	on_next()
	
	
func on_online() -> void:
	join_host_panel.visible = !join_host_panel.visible
	
	
func on_join() -> void:
	on_next()
	Network.join(server_ip.text)
	
	
func on_host() -> void:
	on_next()
	Network.host(10)
	
	
func on_next() -> void:
	Data.set_char_value("alias", character_name.text)
	Data.load_char_save(character_name.text)
	Data.save_config_value("last_character", character_name.text)
	
	
func on_defaults():
	$VBoxContainer.visible = false
	$DefaultsMenu.visible = true


func on_defaults_hide():
	$VBoxContainer.visible = true
	$DefaultsMenu.visible = false
	Data.load_char_save(Data.get_char_value("alias"))
	character_name.text = Data.get_char_value("alias")
	build_armature()


func on_alias_changed(text):
	Data.set_char_value("alias", text)
	
func build_armature():
	var data = Data.get_char_data().duplicate(true)
	var arm = $MeshInstance/Armature
	for i in data.defaults:
		arm.equip({index=data.defaults[i]})
	for i in ["Head", "Chest", "Gloves", "Legs", "Boots", "Mainhand", "Offhand"]:
		if !data.defaults.has(i):
			arm.equip({index="naked_"+i.to_lower()})
	yield(get_tree().create_timer(0.35), "timeout")
	var anims = arm.anim.get_animation_list()
	var a = randi() % anims.size()
	a = anims[a]
	arm.anim.play(a)
	var phrases = ["There is victory in having fought",
			"Do you have a job for me?",
			"Welcome to the Lucky Crab!",
			"It's not much, but it's ours.",
			"Remember to smash that friend button!"]
	a = randi() % phrases.size()
	a = phrases[a]
	arm.get_node("OverheadSystem").text = ""
	arm.print_overhead_system(a)
	arm.get_node("OverheadSystem/Timer").start(4)
