extends Ability


func _init() -> void:
	index = "Spin Attack"
	animation = "Spin_Attack"
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
	return host.get_animation() != animation


func execute() -> void:
	pass
