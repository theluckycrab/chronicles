extends ActionState


func _init() -> void:
	index = "Circle"
	animation = "Strafe_Left"
	priority = 1
	host = null
	
	
func enter() -> void:
	pass
	
	
func exit() -> void:
	pass
	
	
func can_exit() -> bool:
	return true
	
	
func can_enter() -> bool:
	return host.is_on_floor() and host.get_wasd() == Vector3.ZERO
	
	
func execute() -> void:
	if host.lock_target == null:
		host.acquire_lock_target()
	else:
		var mypos = host.global_transform.origin
		var tpos = host.lock_target.global_transform.origin
		var dir = mypos + mypos.direction_to(tpos)
		var dist = mypos.distance_to(tpos)
		if dist > 3:
			host.add_force(Vector3.BACK.rotated(Vector3.UP, host.armature.rotation.y))
			host.lock_on()
		#host.armature.face(dir)
	pass
