extends Node

signal history_received

var peer = NetworkedMultiplayerENet.new()
var token = null

func join(ip = "127.0.0.1", port = 5555) -> void:
	peer.create_client(ip, port)
	get_tree().network_peer = peer
	
remote func fetch_token():
	rpc_id(1, "return_token", token)
	
remote func receive_token_verification(verified:bool):
	if verified:
		print("Connect now!")
	
