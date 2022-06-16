class_name Ability
extends ActionState


var done = false


func _init() -> void:
	index = "Fading Horizon"
	animation = "Fading_Horizon_1"
	priority = 2
	host = null


func enter() -> void:
	show_weapon()
	pass


func exit() -> void:
	combat_check()
	pass


func can_enter() -> bool:
	return host.is_on_floor()


func can_exit() -> bool:
	return done and host.get_animation() != animation


func execute() -> void:
	pass


func show_weapon() -> void:
	host.npc("show_weapon", {})
	host.weaponbox_strike()
	
	
func hide_weapon() -> void:
	host.npc("hide_weapon", {})
	host.weaponbox_ghost()


func combat_check() -> void:
	done = false
	host.acquire_lock_target()
	if !is_instance_valid(host.lock_target):
		host.npc("hide_weapon", {})
		host.set_in_combat(false)
		host.at_war = false
	host.weaponbox_ghost()
