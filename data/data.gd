extends Node
var reference = ReferenceList.new()
signal data_ready

func _ready() -> void:
	print("building reference database")
	reference.build_list("res://data")
	call_deferred("emit_signal", "data_ready")


func get_reference(index):
	return reference.list[index]
	
	
func get_reference_instance(index, register = true):
	var object = reference.get_data(index).duplicate()
	if register:
		object.net_stats.netID = Network.nid_gen()
		object.net_stats.netOwner = Network.nid()
		object.net_stats.base_data_index = index
		Network.relay_signal("register_object", object.net_stats.net_sum())
	#return get_reference(index).duplicate()
	return object
