extends Node

var peer = NetworkedMultiplayerENet.new()
var netID_count = 0
var nide = 1

var net_objects = {}

func set_nid():
	nide = get_tree().get_network_unique_id()
	
func nid():
	return nide
	
func nid_gen():
	netID_count += 1
	return netID_count

func relay_signal(sig, args) -> void:
	rpc("emit", sig, args)
	
func _ready():
	var _dicks = Events.connect("register_object", self, "on_register_object")
	var _discard = Events.connect("network_command", self, "on_net_command")
	host()


remotesync func emit(sig, args) -> void:
	Events.emit_signal(sig, args)
	
	
func host(players = 1, port = 5555) -> void:
	peer.close_connection()
	peer.create_server(port, players)
	get_tree().network_peer = peer
	netID_count = nid()
	
	
func join(ip = "127.0.0.1", port = 5555) -> void:
	peer.close_connection()
	peer.create_client(ip, port)
	get_tree().network_peer = peer
	netID_count = nid()


remotesync func on_register_object(args):
	print("registering ", args, " as ", args.netID)
	if args.netOwner != Network.nid():
		print("dup")
		if args.base_data_index == "player":
			for i in get_node("/root/SceneManager").current_scene.get_children():
				if "net_stats" in i:
					if i.netID == args.netID:
						net_objects[args.netID] = i
			net_objects[args.netID].netID = args.netID
			net_objects[args.netID].net_stats.netOwner = args.netID
			return
		net_objects[args.netID] = Data.get_reference_instance(args.base_data_index, false)
	else:
		print("ref")
		net_objects[args.netID] = instance_from_id(args.original_instance_id)
	pass

func on_net_command(args):
	print("Network.on_net_command args : ", args)
	if net_objects.has(args.sender):
		net_objects[args.sender].call(args.command, args)

func get_net_object(netID):
	return net_objects[netID]
	
remotesync func request_history():
	var history = []
	for i in net_objects:
		if "net_stats" in net_objects[i]:
			history.append(net_objects[i].net_stats.net_sum())
	rpc_id(get_tree().get_rpc_sender_id(), "receive_history", history)
	
remotesync func receive_history(history):
	print(history)
