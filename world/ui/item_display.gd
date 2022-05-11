class_name ItemDisplay
extends Control

export(Resource) onready var item = item as Item
onready var name_label = $VBoxContainer/Name
onready var slot_label = $VBoxContainer/Slot
onready var ability_label = $VBoxContainer/Ability
onready var description_label = $VBoxContainer/Description
onready var tags_label = $VBoxContainer/Tags

func _ready():
	var stats = item.stats
	name_label.text = stats.item_name
	slot_label.text = str(Item.Slots.keys()[stats.slot])
	ability_label.text = stats.ability.ability_name
	description_label.text = stats.description
	tags_label.text = str(stats.tags)
