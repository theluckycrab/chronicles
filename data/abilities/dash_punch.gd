extends Ability

func _init() -> void:
	index = "Dash Punch"
	animation = "Dash_Punch"
	priority = 2
	host = null


func enter() -> void:
	host.armature.anim.connect("keyframe", self, "on_keyframe", [], CONNECT_ONESHOT)
	host.hide_weapon()
	pass


func exit() -> void:
	combat_check()
	pass


func can_enter() -> bool:
	return host.is_on_floor()


func can_exit() -> bool:
	return host.get_animation() != animation


func execute() -> void:
	pass
	
func on_keyframe():
	var projectile = Data.get_projectile("melee_aux").instance()
	projectile.damage = host.get_equipped("Mainhand").get_damage()
	host.add_child(projectile)
	projectile.get_node("Hitbox").owner = host
	projectile.global_transform.origin = host.armature.get_node("HitOrigin").global_transform.origin
	

