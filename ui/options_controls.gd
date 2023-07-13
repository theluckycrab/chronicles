extends VBoxContainer

onready var invert_x = $InvertX
onready var invert_y = $InvertY
onready var h_sens = $HSens/HSlider
onready var v_sens = $VSens/HSlider

func _ready():
	invert_x.connect("toggled", self, "on_invert_x")
	invert_y.connect("toggled", self, "on_invert_y")
	h_sens.connect("value_changed", self, "on_h_sens")
	v_sens.connect("value_changed", self, "on_v_sens")

func load_config():
	invert_x.pressed = Data.get_config_value("invert_x")
	invert_y.pressed = Data.get_config_value("invert_y")
	h_sens.value = Data.get_config_value("h_sens")
	v_sens.value = Data.get_config_value("v_sens")
	
func on_invert_x(on):
	Data.set_config_value("invert_x", on)
	
func on_invert_y(on):
	Data.set_config_value("invert_y", on)

func on_h_sens(v):
	Data.set_config_value("h_sens", v)
	
func on_v_sens(v):
	Data.set_config_value("v_sens", v)
