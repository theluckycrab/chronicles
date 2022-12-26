extends Node

var port = 5555
var ip = "127.0.0.1"
var peer = NetworkedMultiplayerENet.new()

func join():
	peer.connect("connection_succeeded", self, "on_connection_succeeded")
	peer.connect("connection_failed", self, "on_connection_failed")
	peer.create_client(ip, port)
	get_tree().network_peer = peer
	
func on_connection_succeeded():
	print("Online")
	
func on_connection_failed():
	print("Failed to join")

func _ready():
	join()
	
remote func receive_map_history(history):
	for i in history:
		if history[i].size() > 0:
			npc(history[i][history[i].keys()[0]])
			print("[History] ", history[i])
		
	var args = {"uuid":178, "function":"spawn", "unit":"player", "position":Vector3(0, 5, -5)}
	Server.npc(args)

remote func npc(args):
	print("[NPC] ", args)
	if args.has("function"):
		get_node("/root/"+str(args.uuid)).call(args.function, args)
	
	
	
	
	
