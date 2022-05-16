extends Node

signal data_ready

var reference = ReferenceList.new()


func _ready() -> void:
	reference.build_list("res://data")
	call_deferred("emit_signal", "data_ready")
	print("Data ready")


func get_reference(index):
	return reference.list[index]
	
	
func get_reference_instance(index):
	var object = reference.get_data(index)
	if object is Resource:
		return object.duplicate()
	elif object is String:
		return load(object).instance()
