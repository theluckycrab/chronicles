extends Node
class_name Inventory

var item_list = []
var equipped_items = {}
var defaults = {}

var interfaces = [IContainer.new(self)]

func equip(item: BaseItem) -> void:
	var slot = item.get_slot()
	if equipped_items.has(slot):
		unequip(slot)
	equipped_items[slot] = item
	
func unequip(slot: String) -> void:
	if equipped_items.has(slot):
		equipped_items.erase(slot)
	
func get_equipped(slot: String) -> BaseItem:
	if equipped_items.has(slot):
		return equipped_items[slot]
	else:
		return null
	
func get_default(slot: String) -> BaseItem:
	if defaults.has(slot):
		return defaults[slot]
	else:
		return null
	
func set_default(item: BaseItem) -> void:
	var slot = item.get_slot()
	if defaults.has(slot):
		defaults.erase(slot)
	defaults[slot] = item
	pass

#IContainer
func add_item(item: BaseItem) -> void:
	item_list.append(item)
	
func remove_item(item: String) -> void:
	item_list.erase(item)
	
func get_items() -> Array:
	return item_list
