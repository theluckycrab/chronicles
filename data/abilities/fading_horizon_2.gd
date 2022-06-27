extends Ability


func _init() -> void:
	index = "Fading Horizon 2"
	animation = "Fading_Horizon_2"
	priority = 2
	host = null


func enter() -> void:
	#show_weapon()
	pass


func exit() -> void:
	yield(host.get_tree().create_timer(0.35), "timeout")
	completed()
	combat_check()
	pass


func can_enter() -> bool:
	return host.is_on_floor()


func can_exit() -> bool:
	return host.get_animation() != animation and !host.armature.is_using_root_motion()
