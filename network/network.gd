extends Node

var peer = NetworkedMultiplayerENet.new()
var netID_count = 0
var nid = 1
var map = ""
var alias = "Player" setget , get_alias

var net_objects = {}
var command_history = {}
var map_masters = {}


func _ready():
	var _discard = Events.connect("network_command", self, "on_net_command")
	var _disc = peer.connect("connection_succeeded", self, "on_connection_succeeded")
	var _dicks = Events.connect("register", self, "on_register")
	var _dongs = Events.connect("unregister", self, "on_unregister")
	var _ding = Events.connect("save_data_loaded", self, "on_save_data_loaded")
	print("Network ready")
	
	
#connection
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
	
	
#signal response
func on_connection_succeeded() -> void:
	set_nid()
	

func on_peer_disconnected(who) -> void:
	for i in map_masters:
		if map_masters[i] == who:
			map_masters.erase(who)
			rpc("sub_host_migration", who)
	relay_signal("unregister", {netID=who})
	
	
func on_register(args) -> void:
	if map == args.map:
		if !net_objects.has(args.netID):
			spawn(args)
			
			
func on_unregister(args) -> void:
	if net_objects.has(args.netID) and args.map == map:
		var object = net_objects[args.netID]
		net_objects.erase(args.netID)
		if is_instance_valid(object):
			print("unregister ", args.netID)
			object.queue_free()
		
		
func on_net_command(args) -> void:
	if args.map != map:
		return
	if args.command != "net_sync":
			command_history[nid_gen()] = args
	if net_objects.has(args.sender):
		if is_instance_valid(net_objects[args.sender]):
			net_objects[args.sender].call_deferred(args.command, args)
		else:
			print(args.sender, " not valid")
	
	
#directly called
func transition(scene:String) -> void:
	if get_tree().network_peer:
		map = scene 
		rpc("sub_host_migration", get_nid()) 
		rpc_id(1, "request_history", scene)


func spawn(args:Dictionary) -> void:
	var object
	if args.netOwner == get_nid():
		if is_instance_valid(instance_from_id(args.original_instance_id)):
			print("spawning already exists ", args.netID)
			net_objects[args.netID] = instance_from_id(args.original_instance_id)
		return
	else:
		print("spawning new", args)
		object = Data.get_reference_instance(args.index)
		net_objects[args.netID] = object
		object.net_stats.netID = args.netID
		object.net_stats.netOwner = args.netOwner
		object.net_stats.history = args.history.duplicate(true)
		object.net_stats.index = args.index
		object.net_stats.original_instance_id = args.original_instance_id
		object.net_stats.map = args.map
		Events.emit_signal("spawn", object)
		

func relay_signal(sig, args) -> void:
	args.map = map
	rpc("emit", sig, args)
	
	
func nid_gen() -> int:
	netID_count += 1
	return netID_count
	
	
func set_nid() -> void:
	nid = get_tree().get_network_unique_id()
	netID_count = nid
	

	
		
#query
func get_map_from_netID(who: int):
	if is_instance_valid(get_net_object(who)):
		return net_objects[who].net_stats.map
	else:
		return null
		
		
func get_nid() -> int:
	return nid
	
	
func get_net_object(netID):
	if net_objects.has(netID):
		return net_objects[netID]
	else:
		return null
		
		
func get_map_master(tmap: String, who: int) -> int:
	if !map_masters.has(tmap):
		map_masters[tmap] = who
		print(who, " now owns ", tmap)
		return who
	return map_masters[tmap]


func get_alias() -> String:
	return Data.get_saved_value("alias")

#remote functions
remotesync func sub_host_migration(who: int) -> void:
	var tmap = "not set"
	if get_net_object(who):
		tmap = get_map_from_netID(who)
		on_unregister({netID=who, map=tmap})
	else:
		return
	if !map_masters.has(tmap) or map_masters[tmap] != who:
		return
	var alternate = null
	for i in net_objects:
		if i != who and net_objects[i] is Player:
			alternate = i
			break
	if alternate:
		for i in net_objects:
			if is_instance_valid(net_objects[i]) and !net_objects[i] is Player:
				net_objects[i].net_stats.netOwner = alternate
		rpc("set_map_master", tmap, alternate)
	else:
		rpc("set_map_master", tmap, "")
		
		
remotesync func emit(sig, args) -> void:
	Events.emit_signal(sig, args)
	
	
remotesync func request_history(tmap: String) -> void:
	var who = get_tree().get_rpc_sender_id()
	var host = get_map_master(tmap, who)
	rpc_id(host, "send_history", get_tree().get_rpc_sender_id(), map_masters, tmap)
	print(host, " sending history to ", get_tree().get_rpc_sender_id(), " for ", tmap)
	
	
remotesync func send_history(who: int, masters: Dictionary, tmap: String) -> void:
	var history = {}
	for i in net_objects:
		if is_instance_valid(net_objects[i]):
			history[i] = net_objects[i].net_stats.net_sum()
	rpc_id(who, "receive_history", history, command_history, masters, tmap)
	print(get_nid(), " sent history to ", who, " for ", tmap)
	
	
remotesync func receive_history(history: Dictionary, commands: Dictionary,\
		 masters: Dictionary, tmap: String) -> void:
	map_masters = masters.duplicate(true)
	command_history = commands.duplicate(true)
	net_objects.clear()
	map = tmap
	for i in history:
		on_register(history[i])
		print(i)
		
	for i in commands:
		if net_objects.has(commands[i].sender):
			if is_instance_valid(net_objects[commands[i].sender]):
				net_objects[commands[i].sender].call_deferred(commands[i].command, commands[i])
				print(commands[i])
	print("history received from ", get_tree().get_rpc_sender_id(), "\n")
	
	
remotesync func set_map_master(tmap: String, who) -> void:
	if who == null:
		map_masters.erase(tmap)
	else:
		map_masters[tmap] = who
		print(who, " now owns ", tmap)
