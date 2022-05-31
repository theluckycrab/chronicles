extends Control

var active = false setget , get_active

onready var item_menu = $ItemMenu
onready var equipment_display = $EquipmentDisplay
onready var host = get_parent()

	
func get_active():
	return item_menu.active or equipment_display.active
