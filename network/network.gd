extends Node

var peer = NetworkedMultiplayerENet.new()
var netID_count = 0

var net_objects = {}

func nid():
	return get_tree().get_network_unique_id()
	
func nid_gen():
	netID_count += 1
	return netID_count

func relay_signal(sig, args) -> void:
	rpc("emit", sig, args)
	
	
func _ready():
	var _dicks = Events.connect("register_object", self, "on_register_object")
	var _discard = Events.connect("net_command", self, "on_net_command")


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


func on_register_object(args):
	if args.netOwner != Network.nid():
		net_objects[args.netID] = Data.get_reference_instance(args.base_data_index)
	else:
		net_objects[args.netID] = instance_from_id(args.original_instance_id)
	net_objects[args.netID].net_stats.mods = args.mods.duplicate(true)
	pass

func on_net_command(args):
	net_objects[args.host].call(args.command, args)

func get_net_object(netID):
	return net_objects[netID]
