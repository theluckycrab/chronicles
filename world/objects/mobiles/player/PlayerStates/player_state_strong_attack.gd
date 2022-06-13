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
		animation = weapon.strong
	host.weaponbox_strike()
	pass
	
	
func exit() -> void:
	host.weaponbox_ghost()
	pass
	
	
func can_exit() -> bool:
	return host.get_animation() != animation
	
	
func can_enter() -> bool:
	return host.is_on_floor()
	
	
func execute() -> void:
	pass
