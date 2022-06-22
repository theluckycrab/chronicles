class_name Inventory
extends Spatial

var items = []
		
var defaults_dict = {
	#"Head":Data.get_item("naked_head"),
	#"Mainhand":Data.get_item("katana"),
	#"Offhand":Data.get_item("naked_offhand"),
	#"Boots":Data.get_item("naked_feet"),
		}

onready var equipment_dict = defaults_dict.duplicate(true)
		
onready var host = get_parent()

func get_item_list() -> Array:
	return items
	
	
func add_item(item:Item) -> void:
	items.append(item)

func get_defaults_dict() -> Dictionary:
	return defaults_dict.duplicate(true)


func equip(item:Item) -> void:
	equipment_dict[item.get_slot()] = item
	if !item.has_tag("Default"):
		if items.has(item):
			items.erase(item)
	

func get_default(slot:String):
	if defaults_dict.has(slot):
		return defaults_dict[slot]
	else:
		return null


func get_equipped(slot:String):
	if equipment_dict.has(slot):
		return equipment_dict[slot]
	else:
		return null
		
		
func get_all_equipped():
	return equipment_dict
		
		
func set_default(slot:String, item:Item) -> void:
	defaults_dict[slot] = item
	defaults_dict[slot].add_tag("Default")

func _exit_tree():
	Data.clear_char_inventory()
	for i in items:
		Data.save_char_value("inventory", i)
