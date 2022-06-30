extends Ability

var stage2 = load("res://data/abilities/fading_horizon_2.gd").new()

var ready = false

func _init() -> void:
	index = "Fading Horizon"
	animation = "Fading_Horizon_1"
	priority = 2
	host = null
	stage2.connect("completed", self, "on_completed")


func enter() -> void:
	keyframe_connect()
	animation = "Fading_Horizon_1"
	show_weapon()
	host.weaponbox_ghost()
	done = false
	pass


func exit() -> void:
	keyframe_disconnect()
	combat_check()
	completed()
	done = false
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
		if Input.is_action_just_released("mainhand") or ! host is Player:
			animation = "Fading_Horizon_2"
			host.play({"animation":animation, "motion":true})
			host.npc("play", {"animation":animation, "motion":true})
			done = true

func on_completed():
	completed()

func on_keyframe():
	#host.npc("instantiate_projectile", {"index":"melee_aux"})
	pass
