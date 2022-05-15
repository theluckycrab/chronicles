extends Node
var reference = ReferenceList.new()
signal data_ready

func _ready() -> void:
	print("building reference database")
	reference.build_list("res://data")
	call_deferred("emit_signal", "data_ready")
	print("Data ready")


func get_reference(index):
	return reference.list[index]
	
	
func get_reference_instance(index, register = true):
	var object = reference.get_data(index)
	if object is Resource:
		return object.duplicate()
	elif object is String:
		return load(object).instance()
