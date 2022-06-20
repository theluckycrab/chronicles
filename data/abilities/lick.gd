extends Ability

func _init() -> void:
	index = "Lick"
	animation = "Equip"
	priority = 2
	host = null


func enter() -> void:
	keyframe_connect()
	#host.hide_weapon()
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
	pass
	
func on_keyframe():
	var projectile = Data.get_projectile("melee_aux").instance()
	projectile.damage.damage = 1
	projectile.damage.tags = ["Player", "Unblockable"]
	host.add_child(projectile)
	projectile.connect("got_blocked", host, "on_got_blocked", [], CONNECT_ONESHOT)
	projectile.get_node("Hitbox").owner = host
	projectile.global_transform.origin = host.armature.get_node("HitOrigin").global_transform.origin
	

