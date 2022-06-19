extends Ability

func _init() -> void:
	index = "Throw"
	animation = "Fading_Horizon_2"
	priority = 2
	host = null


func enter() -> void:
	keyframe_connect()
	host.hide_weapon()
	pass


func exit() -> void:
	keyframe_disconnect()
	combat_check()
	pass


func can_enter() -> bool:
	return host.is_on_floor()


func can_exit() -> bool:
	return host.get_animation() != animation


func execute() -> void:
	pass
	
func on_keyframe():
	var projectile = Data.get_projectile("throwing_knife").instance()
	projectile.damage = host.get_equipped("Mainhand").get_damage()
	host.add_child(projectile)
	projectile.connect("got_blocked", host, "on_got_blocked", [], CONNECT_ONESHOT)
	projectile.get_node("Hitbox").owner = host
	projectile.global_transform.origin = host.armature.get_node("HitOrigin").global_transform.origin
	projectile.rotation = host.armature.rotation

