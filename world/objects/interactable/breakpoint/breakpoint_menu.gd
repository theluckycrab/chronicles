extends Control

var host = null

signal open_defaults

onready var spawn = $Panel/VBoxContainer/HBoxContainer/SpawnEnemyButton
onready var set_defaults = $Panel/VBoxContainer/HBoxContainer/SetDefaultsButton
onready var defaults_menu = $DefaultsMenu
onready var exit = $Panel/VBoxContainer/ExitButton

func _ready():
	spawn.connect("button_down", self, "on_spawn")
	set_defaults.connect("button_down", self, "on_set_defaults")
	exit.connect("button_down", self, "on_exit")
	defaults_menu.connect("visibility_changed", self, "on_def_menu_vis")
	
func _physics_process(_delta):
	if visible:
		if Input.is_action_just_pressed("ui_cancel"):
			on_exit()
	
func on_spawn():
	var object = Data.get_reference_instance("target_dummy")
	add_child(object)
	object.global_transform.origin = Vector3(0,5,0)
	on_exit()

func on_set_defaults():
	defaults_menu.show()
	
func on_exit():
	hide()
	Input.call_deferred("set_mouse_mode", Input.MOUSE_MODE_CAPTURED)
	
func on_def_menu_vis():
	if defaults_menu.visible:
		$Panel.visible = false
	else:
		$Panel.visible = true
		host.inventory.equipment_dict = {}
		host.inventory.defaults_dict = {}
		host.init_defaults()
#		var equipped = host.get_all_equipped()
#		for i in equipped:
#			if equipped[i].has_tag("Default"):
#				host.destroy(i)
#		var character = Data.get_char_data()
#		for i in character.defaults:
#			if character.defaults[i] != null:
#				var di = character.defaults[i]
#				var ei = host.get_equipped(i)
#				if ei == null:
#					host.set_default(di)
#					host.equip(di)

