extends PlayerActionState

func _init() -> void:
	index = "Strong Attack"
	animation = "Draw"
	priority = 1
	host = null
	
	
func enter() -> void:
	var weapon = host.get_equipped("Mainhand")
	if weapon == null:
		return
	else:
		animation = weapon.get_strong_attack()
	pass
	
	
func exit() -> void:
	pass
	
	
func can_exit() -> bool:
	return host.get_animation() != animation
	
	
func can_enter() -> bool:
	return host.is_on_floor()
	
	
func execute() -> void:
	pass
