extends Node

var peer = NetworkedMultiplayerENet.new()
var netID_count = 0
var nid = 1
var map = ""

var net_objects = {}
var command_history = {}
var map_masters = {}
var online_players = {}
var register = []
		


func _ready():
	var _discard = Events.connect("network_command", self, "on_net_command")
	var _disc = peer.connect("connection_succeeded", self, "on_connection_succeeded")
	var _dicks = Events.connect("register", self, "on_register")
	var _dongs = Events.connect("unregister", self, "on_unregister")
	var _d = Events.connect("scene_change_request", self, "on_scene_change_request")
	print("Network ready")
	
	
func on_connection_succeeded() -> void:
	set_nid()
	
	
func on_scene_change_request(scene):
	map = scene


func on_register(args) -> void:
	if map == args.map:
		if !net_objects.has(args.netID):
			spawn(args)
			
	
func spawn(args):
	var object
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
		object.net_stats.map = args.map
		Events.emit_signal("spawn", object)
		
		
func on_unregister(args) -> void:
	#print("unregister : ", args)
	if net_objects.has(args.netID):
		var object = net_objects[args.netID]
		net_objects.erase(object)
		if is_instance_valid(object):
			object.queue_free()
		
		
func on_net_command(args) -> void:
#	if !map_masters.has(map):
#		print(map, "no map", args)
#		return
	if map_masters.has(map) and get_nid() == map_masters[map]:
		if args.command != "net_sync":
			command_history[nid_gen()] = args
	if net_objects.has(args.sender):
		if is_instance_valid(net_objects[args.sender]):
			net_objects[args.sender].call(args.command, args)
		

func on_peer_disconnected(who) -> void:
	rpc("remove_peer", who)
	
	
remotesync func remove_peer(who) -> void:
	var swap_map = null
	if net_objects.has(who):
		swap_map = net_objects[who].net_stats.map
		net_objects[who].queue_free()
		net_objects.erase(who)
	if swap_map != map:
		return
	
	var alternate = null
	for i in net_objects:
		if i != who and net_objects[i] is Player:
			alternate = net_objects[i].net_stats.netOwner
			break
			
	if alternate:
		for i in net_objects:
			if is_instance_valid(net_objects[i]):
				net_objects[i].net_stats.netOwner = alternate
		
	map_masters[swap_map] = alternate
	rpc_id(1, "set_map_master", swap_map, alternate)
	print(who, " alternate ", alternate)
		
func relay_signal(sig, args) -> void:
	args.map = map
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
		
		
remotesync func request_history(tmap) -> void:
	var who = get_tree().get_rpc_sender_id()
	var host = get_map_master(tmap, who)
	rpc_id(host, "send_history", get_tree().get_rpc_sender_id(), map_masters)
	
remotesync func send_history(who, masters):
	var history = {}
	for i in net_objects:
		if is_instance_valid(net_objects[i]):
			history[i] = net_objects[i].net_stats.net_sum()
	rpc_id(who, "receive_history", history, command_history, masters)
	
	
remotesync func receive_history(history, commands, masters) -> void:
	map_masters = masters.duplicate(true)
	command_history = commands.duplicate(true)
	for i in history:
		on_register(history[i])
		
	for i in commands:
		if net_objects.has(commands[i].sender):
			net_objects[commands[i].sender].call_deferred(commands[i].command, commands[i])


remotesync func remove_map_master(tmap):
	map_masters[tmap] = null


func get_map_master(tmap, who):
	if !map_masters.has(tmap) or !map_masters[tmap] is int:
		map_masters[tmap] = who
		return who
	return map_masters[tmap]
	

remotesync func set_map_master(tmap, who):
	map_masters[tmap] = who
