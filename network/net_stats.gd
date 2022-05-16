extends Reference
class_name NetStats

var netID: int = Network.get_nid()
var netOwner: int = Network.get_nid()
var base_data_index: String
var history = {}
var original_instance_id: int = 0


func _init(index = "debug_item") -> void:
	base_data_index = index
	

func net_sum() -> Dictionary:
	var dic = {
			netID = netID,
			netOwner = netOwner,
			index = base_data_index,
			history = history.duplicate(true),
			original_instance_id = original_instance_id
	}
	return dic


func npc(function:String, args: Dictionary = {}) -> void:
	args["command"] = function
	args["sender"] = netID
	for i in args:
		if i is Object and "net_stats" in args[i]:
			args[i] = args[i].net_stats.net
	history[Network.nid_gen()] = args.duplicate(true)
	Network.relay_signal("network_command", args.duplicate(true))


func register() -> void:
	var args: = {
			index = base_data_index,
			netID = netID,
			netOwner = netOwner,
			history = history.duplicate(true),
			original_instance_id = original_instance_id
	}
	Network.relay_signal("register", args)


func replay_history() -> void:
	for i in history:
		Network.net_objects[netID].call(history[i].command, history[i])
