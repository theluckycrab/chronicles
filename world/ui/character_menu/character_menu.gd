extends Control

onready var host = get_parent().get_parent().get_parent()
onready var inventory = $HBoxContainer/InventoryManager
onready var pouch = $HBoxContainer/InventoryManager2

#func _ready():
#	yield(get_tree().create_timer(1), "timeout")
#	inventory.inventory = host.inventory.items
#	pouch.inventory = host.inventory.pouch
#	inventory.layout()
#	pouch.layout()
#	inventory.connect("inventory_changed", self, "on_inventory_changed")
#	pouch.connect("inventory_changed", self, "on_pouch_changed")
#	connect("visibility_changed", self, "on_visibility_changed")

func on_visibility_changed():
	if visible:
		inventory.layout()
		pouch.layout()
	
func on_inventory_changed(items):
	#host.inventory.items.clear()
	for i in items:
		host.inventory.add_item(i)
	pass
	
func on_pouch_changed(items):
	#host.inventory.pouch.clear()
	for i in items:
		host.inventory.add_item_to_pouch(i)
	pass
