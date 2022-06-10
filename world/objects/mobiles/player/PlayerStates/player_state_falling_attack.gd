extends PlayerActionState


func _init() -> void:
	index = "Falling Attack"
	animation = "Fall"
	priority = 1
	host = null


func enter() -> void:
	var weapon = host.get_equipped("Mainhand")
	if weapon == null:
		return
	else:
		animation = weapon.get_falling_attack()
	pass
	
	
func exit() -> void:
	pass
	
	
func can_exit() -> bool:
	return host.get_animation() == ""
	
	
func can_enter() -> bool:
	return !host.is_on_floor()
	
	
func execute() -> void:
	host.add_force(host.get_wasd_cam() * 5)
	host.body_face(host.get_wasd_cam())
	host.add_force(Vector3.DOWN * 5)
	print(host.armature.weaponbox.state == Hitbox.states.STRIKE)
	
	pass
