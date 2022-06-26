extends Ability

var ready = false

func _init() -> void:
	index = "Fading Horizon"
	animation = "Fading_Horizon_1"
	priority = 2
	host = null


func enter() -> void:
	animation = "Fading_Horizon_1"
	show_weapon()
	host.weaponbox_ghost()
	yield(get_tree().create_timer(0.25), "timeout")
	ready = true
	pass


func exit() -> void:
	#combat_check()
	completed()
	ready = false
	pass


func can_enter() -> bool:
	return host.is_on_floor()


func can_exit() -> bool:
	return done and host.get_animation() != animation and host.get_animation() != "Fading_Horizon_2"


func execute() -> void:
	if !done:
		host.npc("play", {"animation":animation, "motion":true})
		host.acquire_lock_target()
		host.lock_on()
	if ready and ! Input.is_action_pressed("mainhand"):
		var stage2 = load("res://data/abilities/fading_horizon_2.gd").new()
		stage2.host = host
		host.set_state(stage2)
