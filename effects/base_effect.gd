extends Node
class_name BaseEffect

var raw
var current
var host

func _init(data, args={}):
	if data is String:
		return
	raw = data
	current = raw
	for i in args:
		data[i] = args[i]
	print(current)
		
func execute():
	pass
	
