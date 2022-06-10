extends Node

var peer = NetworkedMultiplayerENet.new()
var netID_count = 0
var nid = 1

var net_objects = {}
var command_history = {}


func _ready():
	var _discard = Events.connect("network_command", self, "on_net_command")
	var _disc = peer.connect("connection_succeeded", self, "on_connection_succeeded")
	var _dicks = Events.connect("register", self, "on_register")
	var _dongs = Events.connect("unregister", self, "on_unregister")
	print("Network ready")
	
	
func on_connection_succeeded() -> void:
	set_nid()
	

func on_register(args) -> void:
	#print("register : ", args)
	var object
	#print(args)
	if net_objects.has(args.netID):
		#print("skipping")
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
		object.net_stats.index = args.index
		object.net_stats.original_instance_id = args.original_instance_id
		Events.emit_signal("spawn", object)
		
		
func on_unregister(args) -> void:
	#print("unregister : ", args)
	if net_objects.has(args.netID):
		var object = net_objects[args.netID]
		net_objects.erase(object)
		object.queue_free()
		
		
func on_net_command(args) -> void:
	if get_nid() == 1:
		if args.command != "net_sync":
			command_history[nid_gen()] = args
			#print("Network.Logging : ", args)
	if net_objects.has(args.sender):
		if is_instance_valid(net_objects[args.sender]):
			net_objects[args.sender].call(args.command, args)
		

func on_peer_disconnected(who) -> void:
	rpc("remove_peer", who)
	
	
remotesync func remove_peer(who) -> void:
	if net_objects.has(who):
		net_objects[who].queue_free()
		net_objects.erase(who)
		
		
func relay_signal(sig, args) -> void:
	rpc("emit", sig, args)
	
	
remotesync func emit(sig, args) -> void:
	Events.emit_signal(sig, args)
	
	
func host(players = 1, port = 5555) -> void:
	peer.close_connection()
	peer.create_server(port, players)
	get_tree().network_peer = null
	get_tree().network_peer = peer
	peer.connect("peer_disconnected", self, "on_peer_disconnected")
	
	
func join(ip = "127.0.0.1", port = 5555) -> void:
	peer.close_connection()
	peer.create_client(ip, port)
	get_tree().network_peer = null
	get_tree().network_peer = peer


func nid_gen() -> int:
	netID_count += 1
	return netID_count

func set_nid() -> void:
	nid = get_tree().get_network_unique_id()
	netID_count = nid
	
	
func get_nid() -> int:
	return nid
	
	
func get_net_object(netID):
	return net_objects[netID]
		
		
remotesync func request_history() -> void:
	var history = {}
	for i in net_objects:
		if is_instance_valid(net_objects[i]):
			history[i] = net_objects[i].net_stats.net_sum()
	print("sent history")#, history[i])
	rpc_id(get_tree().get_rpc_sender_id(), "receive_history", history, command_history)
	
remotesync func receive_history(history, commands) -> void:
	print("got history")
	for i in history:
		on_register(history[i])
		print("history: ", history[i])
	for i in commands:
		print("command: ", commands[i])
		if net_objects.has(commands[i].sender):
			net_objects[commands[i].sender].call_deferred(commands[i].command, commands[i])
	
