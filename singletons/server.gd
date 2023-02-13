extends Node

"""
	Server is for handling outgoing network requests.
"""

var map = "test_room"

func get_history(next_map):
	rpc_id(1, "send_history", next_map)

func npc(args):
	args["sender"] = get_tree().get_network_unique_id()
	args["map"] = map
	rpc_id(1, "npc", args)
