extends Node
class_name NetStats

var netID = 0
var netOwner = 1
var base_data_index
var mods = {}
var original_instance_id

func _init(index = "debug_item"):
	base_data_index = index
	netID = Network.nid_gen()
	
func _update():
	pass
	
func _sync():
	pass

func net_sum():
	var dic = {
			netID = netID,
			netOwner = netOwner,
			base_data_index = base_data_index,
			mods = mods.duplicate(true),
			original_instance_id = original_instance_id
	}
	return dic
