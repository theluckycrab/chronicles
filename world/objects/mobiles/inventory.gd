class_name Inventory
extends Spatial

var items = [Data.get_item("wizard_hat"),
		 Data.get_item("katana"),
		 Data.get_item("bandana"),
		Data.get_item("debug_item")]
		
var defaults_dict = {
	"Head":Data.get_item("naked_head"),
#	"Mainhand":Data.get_item("naked_mainhand"),
	"Offhand":Data.get_item("naked_offhand"),
	"Boots":Data.get_item("naked_feet"),
		}

onready var equipment_dict = defaults_dict.duplicate(true)
		
onready var host = get_parent()


func _ready() -> void:
	$Display.build_list(items)


func get_item(item_name:String) -> Item:
	for i in items:
		if i.visual.item_name == item_name:
			return i
	return null
	
	
func get_item_list() -> Array:
	return items
	
func add_item(item: Item, count: int = 1) -> void:
	print("adding ", count, " ", item.visual.item_name, " to inventory")
	if !item.internal.is_modified:
		for i in items:
			if i.visual.item_name == item.visual.item_name:
				i.internal.count += count
				print(items[0].visual.item_name, items[0].internal.count)
				return
		item.internal.count = count
		items.append(item)
	else:
		if count > 1:
			for i in count:
				add_item(item)
		else:
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
	if ! defaults_dict.has(item):
		print("I would reduce the count of ", item.get_name(),"s if there was one!")
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
