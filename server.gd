extends Node

var map = "main"

func get_history(map):
	rpc_id(1, "send_history", map)
	
func npc(args):
	args["sender"] = get_tree().get_network_unique_id()
	args["map"] = map
	rpc_id(1, "npc", args)
