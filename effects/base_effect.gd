extends Node
class_name BaseEffect

var raw
var current

func _init(index, args={}):
	raw = Data.get_effect(index)
	current = raw
	for i in args:
		if current.args.has(i):
			current.args[i] = args[i]
	
func _ready():
	current.target.call(current.function, current.args)
