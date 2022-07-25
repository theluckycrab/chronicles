extends Node

signal history_received

var peer = NetworkedMultiplayerENet.new()
var token = null
var latency = 0
var client_clock = 0
var delta_latency = 0
var decimal_collector = 0.0
var latency_array = []

func _physics_process(delta):
	client_clock += int(delta*1000) + delta_latency
	delta_latency = 0
	decimal_collector += (delta * 1000) - int(delta * 1000)
	if decimal_collector >= 1.00:
		client_clock += 1
		decimal_collector -= 1.00

func join(ip = "127.0.0.1", port = 5555) -> void:
	peer.create_client(ip, port)
	get_tree().network_peer = peer
	
	peer.connect("connection_failed", self, "on_connection_failed")
	peer.connect("connection_succeeded", self, "on_connection_succeeded")
	
func _on_connection_failed():
	pass
	
func on_connection_succeeded():
	rpc_id(1, "fetch_server_time", OS.get_system_time_msecs())
	var timer = Timer.new()
	timer.wait_time = 0.5
	add_child(timer)
	timer.autostart = true
	timer.connect("timeout", self, "determine_latency")
	
remote func return_server_time(stime, ctime):
	latency = (OS.get_system_time_msecs() - ctime) / 2
	client_clock = stime + latency
	
func determine_latency():
	rpc_id(1, "determine_latency", OS.get_system_time_msecs())
	
remote func return_latency(ctime):
	latency_array.append(OS.get_system_time_msecs() - ctime / 2)
	if latency_array.size() == 9:
		var total_latency = 0
		latency_array.sort()
		var mid_point = latency_array[4]
		for i in range(latency_array.size()-1, -1, -1):
			if latency_array[i] > (2 * mid_point) and latency_array[i] > 20:
				latency_array.remove(i)
			else:
				total_latency += latency_array[i]
		delta_latency = (total_latency / latency_array.size()) - latency
		latency = total_latency / latency_array.size()
		latency_array.clear()
	
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
