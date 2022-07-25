extends KinematicBody

var player_state

func _physics_process(delta):
	var wasd:Vector3 = Vector3.ZERO
	wasd.x = (Input.get_action_strength("a") - Input.get_action_strength("d"))
	wasd.z = (Input.get_action_strength("w") - Input.get_action_strength("s"))
	move_and_slide(wasd * 5 + Vector3(0,-9,0), Vector3.UP)
	define_player_state()
	#print("Player pos : ", global_transform.origin)

func define_player_state():
	player_state = {
			"T":GameServer.client_clock,
			"P":global_transform.origin
			}
	GameServer.send_player_state(player_state)
