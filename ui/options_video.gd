extends VBoxContainer

onready var fullscreen = $Fullscreen

func _ready():
	fullscreen.connect("toggled", self, "on_fscreen")
		
func load_config():
	fullscreen.pressed = Data.get_config_value("fullscreen")
	
func on_fscreen(on):
	Data.set_config_value("fullscreen", on)
	OS.window_fullscreen = on
