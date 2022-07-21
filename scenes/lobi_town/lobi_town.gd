extends Spatial

var last_world_state = 0
var world_state_buffer = []
const interpolation_offset = 100

func _physics_process(delta):
	var render_time = OS.get_system_time_msecs() - interpolation_offset
	if world_state_buffer.size() > 1:
		while world_state_buffer.size() > 2 and render_time > world_state_buffer[1].T:
			world_state_buffer.remove(0)
		var interpolation_factor = float(render_time - world_state_buffer[0]["T"]) / float(world_state_buffer[1]["T"] - world_state_buffer[0]["T"])
		for player in world_state_buffer[1].keys():
			if str(player) == "T":
				continue
			if player == get_tree().get_network_unique_id():
				continue
			if ! world_state_buffer[0].has(player):
				continue
			if get_node("OtherPlayers").has_node(str(player)):
				var new_position = lerp(world_state_buffer[0][player]["P"], world_state_buffer[1][player]["P"], interpolation_factor)
				get_node("OtherPlayers/"+str(player)).global_transform.origin = new_position
			else:
				spawn_new_player(player, world_state_buffer[1][player]["P"])

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
	p.queue_free()

func update_world_state(world_state):
	if world_state["T"] > last_world_state:
		last_world_state = world_state["T"]
		world_state_buffer.append(world_state)
