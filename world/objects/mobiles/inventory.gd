class_name Inventory
extends Spatial

var items = [Data.get_reference_instance("wizard_hat"),
		 Data.get_reference_instance("bandana"),
		 Data.get_reference_instance("katana")]
		
onready var host = get_parent()

func _ready():
	$Display.build_list(items)


func get_item(item_name):
	for i in items:
		if i.visual.item_name == item_name:
			return i
	pass
	
func add_item(item: Item, count: int = 1) -> void:
	print("adding ", count, " ", item.visual.item_name)
	if !item.internal.is_modified:
		for i in items:
			if i.visual.item_name == item.visual.item_name:
				i.internal.count += count
				print(items[0].visual.item_name, items[0].internal.count)
				return
		item.count = count
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
