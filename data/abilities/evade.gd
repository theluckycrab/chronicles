extends Ability


func _init() -> void:
	index = "Evade"
	animation = "Evade"
	priority = 6
	host = null


func enter() -> void:
	host.npc("guard", {direction="Forward"})
	hide_weapon()
	pass


func exit() -> void:
	host.npc("guard_reset", {})
	show_weapon()
	combat_check()
	completed()
	pass


func can_enter() -> bool:
	return host.is_on_floor()


func can_exit() -> bool:
	return host.get_animation() != animation


func execute() -> void:
	#host.add_force(Vector3.UP * 10)
	pass
