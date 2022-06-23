extends Control

var active = false setget , get_active

onready var item_menu = $ItemMenu
onready var equipment_display = $EquipmentDisplay
onready var host = get_parent()

func _ready():
	var _discard = get_parent().connect("equipped_item", self, "on_equipped_item")
	

func on_equipped_item(item):
	var icon = null
	match item.get_slot():
		"Head":
			icon = $EquipmentDisplay/HeadIcon
		"Offhand":
			icon = $EquipmentDisplay/OffIcon
		"Mainhand":
			icon = $EquipmentDisplay/MainIcon
		"Boots":
			icon = $EquipmentDisplay/BootsIcon
		_:
			return
	icon.item = item.index
	icon._ready()
	
func get_active() -> bool:
	return item_menu.active or equipment_display.active
