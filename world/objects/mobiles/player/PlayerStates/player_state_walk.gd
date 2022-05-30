extends PlayerMoveState

var speed = 5


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
	return true# or host.velocity.controlled == Vector3.ZERO
	
	
func can_enter() -> bool:
	return host.is_on_floor()# and !host.velocity.controlled == Vector3.ZERO
	
	
func execute() -> void:
	if host.can_act():
		var dir = host.get_wasd_cam()
		host.add_force(dir * speed)
		host.body_face(dir)
	pass
	
	
func get_strafe_dir():
#	match host.velocity.controlled.max_axis():
#		Vector3.AXIS_X:
#			if host.velocity.controlled.x > 0:
#				return "Strafe_Right"
#			elif host.velocity.controlled.x < 0:
#				return "Strafe_Left"
#		Vector3.AXIS_Y:
#			if host.velocity.controlled.z > 0:
#				return "Strafe_Forward"
#			elif host.velocity.controlled.z < 0:
#				return "Strafe_Backwards"
	return "Strafe_Forward"
