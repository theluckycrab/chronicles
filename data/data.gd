extends Node
var reference = ReferenceList.new()

func _ready() -> void:
	print("building reference database")
	reference.build_list("res://data")


func get_reference(index):
	return reference.list[index]
	
	
func get_reference_instance(index):
	return get_reference(index).duplicate()
