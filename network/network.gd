extends Node

var peer = NetworkedMultiplayerENet.new()


func relay_signal(sig, args) -> void:
	rpc("emit", sig, args)


remotesync func emit(sig, args) -> void:
	Events.emit_signal(sig, args)
	
	
func host(singleplayer = false) -> void:
	peer.close_connection()
	if singleplayer:
		peer.create_server(5555, 0)
		get_tree().network_peer = peer
		return
	peer.create_server(5555, 4)
	get_tree().network_peer = peer
	
	
func join(ip = "127.0.0.1", port = 5555) -> void:
	peer.close_connection()
	peer.create_client(ip, port)
	get_tree().network_peer = peer
