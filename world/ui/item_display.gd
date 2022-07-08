class_name ItemDisplay
extends Control

signal button_down

export(String) onready var item = Data.get_item(item)
onready var name_label = $VBoxContainer/Name
onready var slot_label = $VBoxContainer/Slot
onready var ability_label = $VBoxContainer/Ability
onready var description_label = $VBoxContainer/Description
onready var tags_label = $VBoxContainer/Tags
onready var button = $Button

func _ready():
	name_label.text = item.item_name
	slot_label.text = item.slot
	ability_label.text = Data.reference.item_list[item.index].active_index
	description_label.text = item.description
	tags_label.text = str(item.tags)
	if ! button.is_connected("button_down", self, "on_button_down"):
		button.connect("button_down", self, "on_button_down")

func on_button_down():
	emit_signal("button_down", self)
	
func refresh(i):
	item = i
	_ready()
