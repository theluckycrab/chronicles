extends Control

var active = false setget , get_active

onready var equipment_display = $EquipmentDisplay
onready var host = get_parent()
	
func get_active() -> bool:
	return equipment_display.active or get_node("/root/SceneManager/Console/VBoxContainer/LineEdit").visible

func _ready():
	yield(get_tree().create_timer(1), "timeout")
	$TabContainer/CharacterMenu.get_node("HBoxContainer/InventoryManager").inventory = \
			host.inventory.items
	$TabContainer/CharacterMenu.get_node("HBoxContainer/InventoryManager").layout()

	$TabContainer/CharacterMenu.get_node("HBoxContainer/InventoryManager2").inventory = \
			["katana", "scimitar", "club"]
			#[Data.get_item("katana"), Data.get_item("scimitar"), Data.get_item("club")]
	$TabContainer/CharacterMenu.get_node("HBoxContainer/InventoryManager2").layout()
