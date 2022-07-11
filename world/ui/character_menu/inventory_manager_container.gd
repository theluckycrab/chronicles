extends Control

signal item_dropped

func can_drop_data(_position, _data):
	return true
	
func drop_data(_position, data):
	emit_signal("item_dropped", data)
