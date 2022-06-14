extends Ability


func _init() -> void:
	index = "Fading Horizon"
	animation = "Fading_Horizon_1"
	priority = 2
	host = null


func enter() -> void:
	animation = "Fading_Horizon_1"
	show_weapon()
	pass


func exit() -> void:
	combat_check()
	pass


func can_enter() -> bool:
	return host.is_on_floor()


func can_exit() -> bool:
	return done and host.get_animation() != animation and host.get_animation() != "Fading_Horizon_2"


func execute() -> void:
	if !done:
		host.play({"animation":animation, "motion":true})
		host.acquire_lock_target()
		host.lock_on()
	if Input.is_action_just_released("mainhand"):
		host.play({"animation":"Fading_Horizon_2", "motion":true})
		done = true
