extends Reference
class_name NetStats

var netID = Network.get_nid()
var netOwner = Network.get_nid()
var base_data_index
var mods = {}
var original_instance_id

func _init(index = "debug_item"):
	base_data_index = index
	
func _update():
	pass
	
func _sync():
	pass

func net_sum():
	var dic = {
			netID = netID,
			netOwner = netOwner,
			index = base_data_index,
			history = mods.duplicate(true),
			original_instance_id = original_instance_id
	}
	return dic

func npc(function, args = {}):
	args["command"] = function
	args["sender"] = netID
	for i in args:
		if i is Object and "net_stats" in args[i]:
			args[i] = args[i].net_stats.net
	Network.relay_signal("network_command", args.duplicate(true))
	pass

func register():
	var args = {
			index = base_data_index,
			netID = netID,
			netOwner = netOwner,
			history = mods.duplicate(true),
			original_instance_id = original_instance_id
	}
	Network.relay_signal("register", args)
