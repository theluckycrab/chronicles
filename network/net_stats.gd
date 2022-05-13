extends Node
class_name NetStats

var netID = 0
var netOwner = 1
var base_data_index
var base_data
var mods = {}

func _init(index = "debug_item"):
	base_data_index = index
	base_data = Data.get_reference(base_data_index)
	netID = Network.nid_gen()
	netOwner = Network.nid()
	
func _update():
	pass
	
func _sync():
	pass
