extends PlayerMoveState


func _init() -> void:
	index = "Walk"
	animation = "Walk"
	priority = -1
	host = null

var sprinting: bool = false


func _controls() -> void:
	pass
	
	
func enter() -> void:
	pass
	
	
func exit() -> void:
	pass
	
	
func can_exit() -> bool:
	return !host.is_on_floor() or host.velocity.controlled == Vector3.ZERO
	
	
func can_enter() -> bool:
	return host.is_on_floor() and !host.velocity.controlled == Vector3.ZERO
	
	
func execute() -> void:
	if host.flags.at_war:
		host.anim.play(get_strafe_dir())
		if Input.is_action_just_pressed("dodge"):
			get_parent().set_state("dodge")
		return
	if Input.is_action_pressed("sprint"):
		host.velocity.controlled *= 2
		host.anim.play("Run")
	if Input.is_action_just_released("sprint"):
		host.anim.play("Walk")
	pass
	
	
func get_strafe_dir():
	match host.velocity.controlled.max_axis():
		Vector3.AXIS_X:
			if host.velocity.controlled.x > 0:
				return "Strafe_Right"
			elif host.velocity.controlled.x < 0:
				return "Strafe_Left"
		Vector3.AXIS_Y:
			if host.velocity.controlled.z > 0:
				return "Strafe_Forward"
			elif host.velocity.controlled.z < 0:
				return "Strafe_Backwards"
	return "Strafe_Forward"
