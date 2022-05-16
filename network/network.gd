extends Node

var peer = NetworkedMultiplayerENet.new()
var netID_count = 0
var nid = 1

var net_objects = {}

func set_nid():
	nid = get_tree().get_network_unique_id()
	netID_count = nid
	
func get_nid():
	return nid
	
func nid_gen():
	netID_count += 1
	return netID_count

func relay_signal(sig, args) -> void:
	rpc("emit", sig, args)
	
func _ready():
	var _discard = Events.connect("network_command", self, "on_net_command")
	var _disc = peer.connect("connection_succeeded", self, "on_connection_succeeded")
	var _dicks = Events.connect("register", self, "on_register")
	print("Network ready")
	
func on_connection_succeeded():
	set_nid()
	rpc_id(1, "request_history")


remotesync func emit(sig, args) -> void:
	Events.emit_signal(sig, args)
	
	
func host(players = 1, port = 5555) -> void:
	peer.close_connection()
	peer.create_server(port, players)
	get_tree().network_peer = peer
	
	
func join(ip = "127.0.0.1", port = 5555) -> void:
	peer.close_connection()
	peer.create_client(ip, port)
	get_tree().network_peer = peer

func on_net_command(args):
	print("Network.on_net_command args : ", args)
	if net_objects.has(args.sender):
		net_objects[args.sender].call(args.command, args)

func get_net_object(netID):
	return net_objects[netID]
	
func on_register(args):
	var object
	if net_objects.has(args.netID):
		return
	if args.netOwner == get_nid() and args.original_instance_id != null:
		net_objects[args.netID] = instance_from_id(args.original_instance_id)
		return
	else:
		object = Data.get_reference_instance(args.index)
		net_objects[args.netID] = object
		object.net_stats.netID = args.netID
		object.net_stats.netOwner = args.netOwner
		object.net_stats.history = args.history.duplicate(true)
		object.net_stats.base_data_index = args.index
		object.net_stats.original_instance_id = args.original_instance_id
		Events.emit_signal("spawn", object)
		
remotesync func request_history():
	var history = {}
	for i in net_objects:
		history[i] = net_objects[i].net_stats.net_sum()
	rpc_id(get_tree().get_rpc_sender_id(), "receive_history", history.duplicate(true))
	pass
	
remotesync func receive_history(history):
	for i in history:
		on_register(history[i])
	for i in history:
		net_objects[i].net_stats.replay_history()
		print("PRINTING HISTORY")
	pass
	
func process_history():
	pass
