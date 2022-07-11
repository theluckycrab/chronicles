extends Control

var active = false setget , get_active

onready var equipment_display = $EquipmentDisplay
onready var host = get_parent()
	
func get_active() -> bool:
	return equipment_display.active or get_node("/root/SceneManager/Console/VBoxContainer/LineEdit").visible
