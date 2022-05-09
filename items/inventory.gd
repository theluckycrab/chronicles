class_name Inventory
extends Spatial

var items = [Data.items["Wizard Hat"].duplicate(), Data.items["Debug Item"].duplicate(), Data.items["Katana"].duplicate()]
var iterator: int = 0


func get_item() -> Item:
	return items[iterator]
	
	
func add_item(item:Item, count: int = 1) -> void:
	var stats = item.stats
	var n_item = Item.new()
	n_item.stats = stats.duplicate(true)

	if !n_item.stats.is_modified:
		for i in items:
			if i.stats.item_name == n_item.stats.item_name:
				i.stats.count += count
				return
		n_item.stats.count = count
		items.append(n_item)
	else:
		if count > 1:
			for i in count:
				add_item(n_item)
		else:
			items.append(n_item)
	
	
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
				break
				return
			else:
				print(count, " " + item.item_name + " removed from inventory.")
				break
				return
