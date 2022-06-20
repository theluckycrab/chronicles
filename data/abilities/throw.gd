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
	host.npc("instantiate_projectile", {"index":"throwing_knife"})

