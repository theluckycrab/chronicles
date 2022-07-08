extends Control

signal item_dropped

func can_drop_data(position, data):
	return true
	
func drop_data(position, data):
	emit_signal("item_dropped", data)
