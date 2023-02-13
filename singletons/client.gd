extends Node

"""
	Client is for managing the client's connection to the server and handling incoming network requests.
"""

var port := 5555
var ip := "108.160.216.96"
var peer := NetworkedMultiplayerENet.new()
var nid := 1

func join() -> void:
	var _discard = peer.connect("connection_succeeded", self, "on_connection_succeeded")
	var _dicsard = peer.create_client(ip, port)
	get_tree().network_peer = peer

remote func npc(args: Dictionary) -> void:
	if args.has("function"):
		if str(args.uuid) == Server.map:
			get_node("/root/Main/"+args.uuid).call(args.function, args)
		else:
			get_node("/root/"+str(args.map)+"/"+str(args.uuid)).call(args.function, args)

func on_connection_succeeded() -> void:
	nid = get_tree().get_network_unique_id()
	print("You have joined ", ip, " as ", nid)

remote func receive_map_history(history: Dictionary) -> void:
	for call_dict in history:
		if history[call_dict].size() > 0:
			for entry in history[call_dict]:
				npc(history[call_dict][entry])

	var args = {"uuid":"test_room", "function":"spawn", "unit":"player", "position":Vector3(-150, -37, 0),
				"unit_uuid":nid}
	Server.npc(args)
