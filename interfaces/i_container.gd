extends BaseInterface
class_name IContainer

func _init(h).(h, "container"):
	pass
	
var item_list: Array

func add_item(_i: BaseItem) -> void:
	pass
	
func remove_item(_i: String) -> void:
	pass
	
func get_items() -> Array:
	return item_list
