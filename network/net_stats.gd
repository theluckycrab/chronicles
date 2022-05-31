extends Reference
class_name NetStats

var netID: int = Network.get_nid()
var netOwner: int = Network.get_nid()
var index: String
var history = {}
var original_instance_id: int = 0

onready var is_dummy = false setget , get_is_dummy
onready var is_master = false setget , get_is_master


func _init(base_index = "debug_item") -> void:
	index = base_index
	

func get_is_dummy() -> bool:
	return !get_is_master()
	
	
func get_is_master() -> bool:
	return netOwner == Network.get_nid()
	

func net_sum() -> Dictionary:
	var dic = {
			netID = netID,
			netOwner = netOwner,
			index = index,
			history = history.duplicate(true),
			original_instance_id = original_instance_id
	}
	return dic


func npc(function:String, args: Dictionary = {}) -> void:
	args["command"] = function
	args["sender"] = netID
	args["netOwner"] = netOwner
	for i in args:
		if i is Object and "net_stats" in args[i]:
			args[i] = args[i].net_stats.net
	Network.relay_signal("network_command", args.duplicate(true))


func register() -> void:
	var args: = net_sum()
	Network.relay_signal("register", args)


func replay_history() -> void:
	for i in history:
		Network.net_objects[netID].call(history[i].command, history[i])
		


