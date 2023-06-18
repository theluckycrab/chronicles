extends Control

onready var save_button = $VBoxContainer/HBoxContainer/SaveButton
onready var exit_button = $VBoxContainer/HBoxContainer/ExitButton

func _ready():
	exit_button.connect("button_down", self, "hide")
	save_button.connect("button_down", self, "hide")
