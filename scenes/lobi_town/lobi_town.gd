extends Spatial

var last_world_state = 0
var world_state_buffer = []
const interpolation_offset = 100

func _physics_process(delta):
	var render_time = GameServer.client_clock - interpolation_offset
	if world_state_buffer.size() > 1:
		while world_state_buffer.size() > 2 and render_time > world_state_buffer[1].T:
			print(render_time," // ", world_state_buffer[1].T)
			world_state_buffer.remove(0)#if we have 3 states and the newest is newer than our delay
		if world_state_buffer.size() > 2:#if we still have 3 states
			print("interpolate")
			var interpolation_factor = float(render_time - world_state_buffer[1]["T"]) / float(world_state_buffer[2]["T"] - world_state_buffer[1]["T"])
			for player in world_state_buffer[2].keys():
				if str(player) == "T":
					continue
				if player == get_tree().get_network_unique_id():
					continue
				if ! world_state_buffer[1].has(player):
					continue
				if get_node("OtherPlayers").has_node(str(player)):
					var new_position = lerp(world_state_buffer[1][player]["P"], world_state_buffer[2][player]["P"], interpolation_factor)
					get_node("OtherPlayers/"+str(player)).global_transform.origin = new_position
				else:
					spawn_new_player(player, world_state_buffer[2][player]["P"])
		elif render_time > world_state_buffer[1].T:
			print("extrapolate")
			var extrapolation_factor = float(render_time - world_state_buffer[0]["T"]) / float(world_state_buffer[1]["T"] - world_state_buffer[0]["T"]) - 1.00
			for player in world_state_buffer[1].keys():
				if str(player) == "T":
					continue
				if player == get_tree().get_network_unique_id():
					continue
				if ! world_state_buffer[0].has(player):
					continue
				if get_node("OtherPlayers").has_node(str(player)):
					var position_delta = (world_state_buffer[1][player]["P"] - world_state_buffer[0][player]["P"])
					var new_position = world_state_buffer[1][player]["P"] + (position_delta * extrapolation_factor)
					get_node("OtherPlayers/"+str(player)).global_transform.origin = new_position
	

func spawn_new_player(who, where):
	if get_tree().get_network_unique_id() == who:
		return
	if get_node_or_null("OtherPlayers/"+str(who)) != null:
		return
	var p = preload("res://mobiles/base_mobile.tscn")
	p = p.instance()
	p.name = str(who)
	get_node("OtherPlayers").add_child(p)
	p.global_transform.origin = where
	
func despawn_player(who):
	var p = get_node_or_null("OtherPlayers/"+str(who))
	if p == null:
		return
	yield(get_tree().create_timer(0.2), "timeout")
	if !world_state_buffer.empty() and ! world_state_buffer.back().keys().has(who):
		p.queue_free()

func update_world_state(world_state):
	if world_state["T"] > last_world_state:
		last_world_state = world_state["T"]
		world_state_buffer.append(world_state)
