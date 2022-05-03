class_name Inventory
extends Spatial

var items = [Item.new()]
var iterator: int = 0


func controls() -> void:
	if Input.is_action_just_pressed("ui_up"):
		iterator += 1
	elif Input.is_action_just_pressed("ui_down"):
		iterator -= 1
	if iterator > items.size() -1:
		iterator = 0
	elif iterator < 0:
		iterator = items.size() -1
		

func get_item() -> TestItem:
	return items[iterator]
	
	
func add_item(item:TestItem, count: int = 1) -> void:
	var stats = item.stats
	var n_item = TestItem.new()
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
	if item is TestItem:
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
