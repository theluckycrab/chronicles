extends Spatial

var last_world_state = 0

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
		world_state.erase("T")
		world_state.erase(get_tree().get_network_unique_id())
		for player in world_state.keys():
			var p = get_node_or_null("OtherPlayers/"+str(player))
			if p != null:
				p.global_transform.origin = world_state[player]["P"]
			else:
				spawn_new_player(player, world_state[player]["P"])
