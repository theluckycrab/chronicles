extends Control

onready var host = get_parent().get_parent().get_parent()

func _ready():
	yield(get_tree().create_timer(1), "timeout")
	$HBoxContainer/InventoryManager.inventory = host.inventory.items
	$HBoxContainer/InventoryManager2.inventory = [Data.get_item("katana"), Data.get_item("club")\
			, Data.get_item("scimitar")]
	$HBoxContainer/InventoryManager.connect("inventory_changed", self, "on_inventory_changed")
	$HBoxContainer/InventoryManager2.connect("inventory_changed", self, "on_pouch_changed")
	$HBoxContainer/InventoryManager.layout()
	$HBoxContainer/InventoryManager2.layout()
	connect("visibility_changed", self, "on_visibility_changed")
	
func on_inventory_changed(items):
	host.inventory.items = items
	pass
	
func on_pouch_changed(items):
	pass

func on_visibility_changed():
	if visible:
		$HBoxContainer/InventoryManager.layout()
		$HBoxContainer/InventoryManager2.layout()
