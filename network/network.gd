extends Node

signal history_received

var peer = NetworkedMultiplayerENet.new()
var netID_count = 0
var map = ""
var alias = "Player" setget , get_alias
var token = null

var net_objects = {}
var command_history = {}
var map_masters = {}


func _ready():
	var _discard = Events.connect("network_command", self, "on_net_command")
	var _dickss = peer.connect("peer_connected", self, "on_peer_connected")
	var _dicka = peer.connect("peer_disconnected", self, "on_peer_disconnected")
	var _dicks = Events.connect("register", self, "on_register")
	var _dongs = Events.connect("unregister", self, "on_unregister")
	print("Network ready")
	#host()
	
#connection
func host(players = 1, port = 5555) -> void:
	peer.close_connection()
	peer.create_server(port, players)
	get_tree().network_peer = null
	get_tree().network_peer = peer
	on_join_successful()
	
func join(ip = "127.0.0.1", port = 5555) -> void:
	peer.close_connection()
	peer.create_client(ip, port)
	get_tree().network_peer = null
	get_tree().network_peer = peer
	
	
remote func on_join_successful():
	print("acknowledged")
	netID_count = get_nid()
	Events.emit_signal("scene_change_request", "main_menu")
	
	
#signal response

func on_peer_connected(who) -> void:
	if get_nid() == 1:
		rpc_id(who, "on_join_successful")
		print(who, " has joined")
	

func on_peer_disconnected(who) -> void:
	for i in map_masters:
		if map_masters[i] == who:
			map_masters.erase(who)
			rpc("sub_host_migration", who, i)
	relay_signal("unregister", {netID=who})
	
	
remote func fetch_token():
	rpc_id(1, "return_token", token)
	
remote func receive_token_verification(verified):
	if verified:
		Events.emit_signal("scene_change_request", "main_menu")
	
	
func on_register(args) -> void:
	if map == args.map:
		if !net_objects.has(args.netID):
			spawn(args)
			
			
func on_unregister(args) -> void:
	if net_objects.has(args.netID) and args.map == map:
		var object = net_objects[args.netID]
		if is_instance_valid(object):
			object.queue_free()
			net_objects.erase(args.netID)
		if args.netID == Network.get_nid():
			Events.emit_signal("scene_change_request", Data.get_saved_char_value("map"))
		
		
func on_net_command(args) -> void:
	if args.map != map:
		return
	if args.command != "net_sync" and !args.has("animation"):
			command_history[nid_gen()] = args
	if net_objects.has(args.sender):
		if is_instance_valid(net_objects[args.sender]):
			net_objects[args.sender].call_deferred(args.command, args)
	
#directly called
func spawn(args:Dictionary) -> void:
	var object
	if args.netOwner == get_nid():
		if is_instance_valid(instance_from_id(args.original_instance_id)):
			#print("spawn already exists ", args.netID)
			net_objects[args.netID] = instance_from_id(args.original_instance_id)
			if net_objects[args.netID].has_method("on_register"):
				net_objects[args.netID].on_register()
		return
	else:
		#print("spawning new", args)
		object = Data.get_reference_instance(args.index)
		net_objects[args.netID] = object
		object.net_stats.netID = args.netID
		object.net_stats.netOwner = args.netOwner
		object.net_stats.history = args.history.duplicate(true)
		object.net_stats.index = args.index
		object.net_stats.original_instance_id = args.original_instance_id
		object.net_stats.map = args.map
		Events.emit_signal("spawn", object)
		

func relay_signal(sig, args, owner_only=false) -> void:
	args.map = map
	if owner_only:
		if args.has("unreliable"):
			rpc_unreliable_id(args.netOwner, "emit", sig, args)
			return
		rpc_id(args.netOwner, "emit", sig, args)
	else:
		if args.has("unreliable"):
			rpc_unreliable("emit", sig, args)
			return
		rpc("emit", sig, args)
	
	
func nid_gen() -> int:
	netID_count += 1
	return netID_count
	
#query
func get_map_from_netID(who: int):
	if is_instance_valid(get_net_object(who)):
		return net_objects[who].net_stats.map
	else:
		return null
		
		
func get_nid() -> int:
	if !is_instance_valid(get_tree().network_peer):
		return 1
	return get_tree().get_network_unique_id()
	
	
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
	return Data.get_saved_char_value("alias")

#remote functions
remotesync func sub_host_migration(who: int, tmap: String) -> void:
	print("subhost")
	on_unregister({netID=who, map=tmap})
	if Network.map != tmap:
		return
	var nobjects = net_objects.duplicate()
	var alternative = null
	
	for i in nobjects:
		if nobjects[i] is Player:
			if alternative == null:
				alternative = i
			elif i < alternative:
				alternative = i
	if alternative == null:
		return
				
		
	for i in net_objects:
		if is_instance_valid(net_objects[i]):
			if net_objects[i].net_stats.netOwner == who:
				net_objects[i].net_stats.netOwner = alternative
				if net_objects[i].has_method("set_ready"):
					net_objects[i].ready = true
				
	rpc_id(1, "set_map_master", tmap, alternative)
		
remotesync func emit(sig, args) -> void:
	Events.emit_signal(sig, args)
	
	
remotesync func request_history(tmap: String) -> void:
	var who = get_tree().get_rpc_sender_id()
	for i in map_masters:
		if map_masters[i] == who:
			rpc("sub_host_migration", who, i)
			map_masters.erase(i)
	var host = get_map_master(tmap, who)
	rpc_id(host, "send_history", get_tree().get_rpc_sender_id(), map_masters, tmap)
	#print(host, " sending history to ", get_tree().get_rpc_sender_id(), " for ", tmap)
	
	
remotesync func send_history(who: int, masters: Dictionary, tmap: String) -> void:
	var history = {}
	for i in net_objects:
		if is_instance_valid(net_objects[i]):
			history[i] = net_objects[i].net_stats.net_sum()
	rpc_id(who, "receive_history", history, command_history, masters, tmap)
	#print(get_nid(), " sent history to ", who, " for ", tmap)
	
	
remotesync func receive_history(history: Dictionary, commands: Dictionary,\
		 masters: Dictionary, tmap: String) -> void:
	map_masters = masters.duplicate(true)
	print(map_masters)
	command_history = commands.duplicate(true)
	net_objects.clear()
	map = tmap
	emit_signal("history_received", history, commands, masters, tmap)
	
	
remotesync func set_map_master(tmap: String, who) -> void:
	if who == null:
		map_masters.erase(tmap)
	else:
		map_masters[tmap] = who
		print(who, " now owns ", tmap)
	rpc("update_map_masters", map_masters.duplicate(true))
	
remotesync func update_map_masters(masters):
	if get_nid() != 1:
		map_masters = masters.duplicate(true)
		
		
remotesync func remove_map_master(tmap):
	print("remove map master")
	if tmap == "" or !map_masters.has(tmap):
		print("map not found")
		return
	if map_masters[tmap] == get_tree().get_rpc_sender_id():
		map_masters.erase(tmap)
		rpc("sub_host_migration", get_tree().get_rpc_sender_id(), tmap)
	else:
		on_unregister({netID=get_tree().get_rpc_sender_id(),map=tmap})
		

remotesync func receive_map_masters(maps):
	map_masters = maps.duplicate()
	Events.emit_signal("map_masters_updated")
	
	
remotesync func fetch_map_masters():
	rpc_id(get_tree().get_rpc_sender_id(), "receive_map_masters", map_masters.duplicate(true))
