extends PlayerMoveState


func _init() -> void:
	index = "Fall"
	animation = "Fall"
	priority = -1
	host = null


func enter() -> void:
	pass
	
	
func exit() -> void:
	pass
	
	
func can_exit() -> bool:
	return host.is_on_floor()
	
	
func can_enter() -> bool:
	return !host.is_on_floor()
	
	
func execute() -> void:
	if Input.is_action_just_pressed("light_attack"):
		host.set_state("falling_attack")
	host.add_force(host.get_wasd_cam() * 5)
	#host.body_face(host.get_wasd_cam())
	host.add_force(Vector3.DOWN * 5)
	#host.lock_on()
	
	pass
