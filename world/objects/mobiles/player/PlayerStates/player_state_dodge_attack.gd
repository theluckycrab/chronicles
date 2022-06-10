extends PlayerActionState


func _init() -> void:
	index = "Dash Attack"
	animation = "Dash_Attack"
	priority = 3
	host = null


func enter() -> void:
	print("dash attacking")
	pass
#	print("dash attack")
#	var weapon = host.get_equipped("Mainhand")
#	if weapon == null:
#		return
#	else:
#		animation = weapon.get_dash_attack()
	#host.weaponbox_strike()
	
func exit() -> void:
	#host.weaponbox_ghost()
	pass
	
	
func can_exit() -> bool:
	print(host.get_animation())
	return host.get_animation() != animation
	
	
func can_enter() -> bool:
	return true
	
	
func execute() -> void:
	var dir = Vector3.BACK.rotated(Vector3.UP, host.armature.rotation.y) * 5
	host.add_force(dir)
	host.body_face(dir)
	print(host.armature.weaponbox.state)
	
