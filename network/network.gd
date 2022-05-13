extends Node

var peer = NetworkedMultiplayerENet.new()
var netID_count = 0

func nid():
	return get_tree().get_network_unique_id()
	
func nid_gen():
	netID_count += 1
	return netID_count

func relay_signal(sig, args) -> void:
	rpc("emit", sig, args)


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
