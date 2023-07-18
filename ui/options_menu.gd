extends Control

onready var save_button = $VBoxContainer/HBoxContainer/SaveButton
onready var exit_button = $VBoxContainer/HBoxContainer/ExitButton

var enter_mouse_mode = Input.MOUSE_MODE_VISIBLE

func _ready():
	self.connect("visibility_changed", self, "on_vis")
	exit_button.connect("button_down", self, "hide")
	save_button.connect("button_down", self, "on_save")
	$VBoxContainer/QuitButton.connect("button_up", get_tree(), "quit")

func on_save():
	Data.save_config()
	hide()
	
func _input(event):
	if event is InputEvent:
		if event.is_action("options_menu") and event.is_pressed():
			if visible:
				hide()
			else:
				show()

func on_vis():
	load_config()
	if visible:
		enter_mouse_mode = Input.get_mouse_mode()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		OS.window_fullscreen = Data.get_config_value("fullscreen")
		Input.set_mouse_mode(enter_mouse_mode)

func load_config():
	Data.load_config()
	for i in $VBoxContainer/TabContainer.get_children():
		if i.has_method("load_config"):
			i.load_config()
