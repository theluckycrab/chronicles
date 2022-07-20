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
		get_node("/root/SceneManager").change_scene("lobi_town")
	
remote func spawn_player(who, where):
	get_node("/root/SceneManager").spawn_new_player(who, where)
	
remote func despawn_player(who):
	get_node("/root/SceneManager").despawn_player(who)

remote func send_player_state(player_state):
	rpc_unreliable_id(1, "receive_player_state", player_state)

remote func receive_world_state(world_state):
	get_node("/root/SceneManager").update_world_state(world_state)
