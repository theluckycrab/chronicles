extends Ability

func _init() -> void:
	index = "Taunt"
	animation = "Taunt"
	priority = 2
	host = null


func enter() -> void:
	keyframe_connect()
	host.hide_weapon()
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
		host.lock_target.lock_target = null
	pass
	

func on_keyframe():
	var targets = get_viewport().get_camera().get_node("LockOnArea")
	targets = targets.get_overlapping_bodies()
	for i in targets:
		if i is BaseMobile and i.get_faction() != "Player":
			i.npc("set_lock_target", {netID=host.net_stats.netID})
	

