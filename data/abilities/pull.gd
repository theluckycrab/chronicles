extends Ability

func _init() -> void:
	index = "Pull"
	animation = "Sheathe"
	priority = 2
	host = null


func enter() -> void:
	keyframe_connect()
	host.hide_weapon()
	if is_instance_valid(host.lock_target):
		host.lock_target.npc("net_set_state", {state="stagger"})
	pass


func exit() -> void:
	keyframe_disconnect()
	combat_check()
	completed()
	pass


func can_enter() -> bool:
	return host.is_on_floor()


func can_exit() -> bool:
	return host.get_animation() != animation


func execute() -> void:
	if is_instance_valid(host.lock_target):
		var dir = host.lock_target.direction_to(host)
		host.lock_target.npc("net_force", {force= dir * 10})
	pass
	

func on_keyframe():
	pass
	

