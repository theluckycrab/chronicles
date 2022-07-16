extends Control

onready var user = $VBoxContainer/LineEdit
onready var password = $VBoxContainer/LineEdit2
onready var login_button = $Button

func _ready():
	login_button.connect("button_down", self, "on_login")
	
func on_login():
	var u = user.text
	var p = password.text
	print("trying to log in as ", u, ":", p)
	Gateway.join(u,p)
