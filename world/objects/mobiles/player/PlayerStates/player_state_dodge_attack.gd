extends PlayerActionState


func _init() -> void:
	index = "Dodge Attack"
	animation = "Fall"
	priority = 2
	host = null


func enter() -> void:
	var weapon = host.get_equipped("Mainhand")
	if weapon == null:
		return
	else:
		animation = weapon.get_dash_attack()
	pass
	
	
func exit() -> void:
	pass
	
	
func can_exit() -> bool:
	return host.get_animation() != animation
	
	
func can_enter() -> bool:
	return host.is_on_floor()
	
	
func execute() -> void:
	host.add_force(host.get_wasd_cam() * 5)
	host.body_face(host.get_wasd_cam())
	
