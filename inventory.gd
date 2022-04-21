class_name Inventory
extends Spatial

var items = {"Donger":TestItem.new()}
var iterator = 0

func controls():
	if Input.is_action_just_pressed("ui_up"):
		iterator += 1
	elif Input.is_action_just_pressed("ui_down"):
		iterator -= 1
	if iterator > items.size() -1:
		iterator = 0
	elif iterator < 0:
		iterator = items.size() -1

func use_item():
	items[iterator]
	pass

func get_item():
	return items[items.keys()[iterator]]
	
func add_item(item, count = 1):
	pass
	
func change_item_count(_item, _count):
	pass
