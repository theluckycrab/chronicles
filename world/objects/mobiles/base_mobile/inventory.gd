class_name Inventory
extends Spatial

var items = []
		
var defaults_dict = {
	"Head":Data.get_item("naked_head"),
	"Mainhand":Data.get_item("katana"),
	"Offhand":Data.get_item("naked_offhand"),
	"Boots":Data.get_item("naked_feet"),
		}

onready var equipment_dict = defaults_dict.duplicate(true)
		
onready var host = get_parent()


func get_item_list() -> Array:
	return items
	
	
func add_item(item:Item) -> void:
	items.append(item)
	
	
func remove_item(item, count: int = 1) -> void:
	if item is Item:
		item = item.stats
	else:
		item = {item_name = item}
		
	for i in items:
		if i.stats.item_name == item.item_name:
			i.stats.count -= 1 
			if i.stats.count < 1: 
				items.erase(i) 
				print(item.item_name + " deleted from inventory.")
				return
			else:
				print(count, " " + item.item_name + " removed from inventory.")
				return


func get_defaults_dict() -> Dictionary:
	return defaults_dict.duplicate(true)


func equip(item:Item) -> void:
	equipment_dict[item.get_slot()] = item
	

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
		
		
func set_default(slot:String, index:String):
	var item = Data.get_item(index)
	defaults_dict[slot] = item
