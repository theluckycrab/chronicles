extends PlayerMoveState

var speed = 7
var dir = Vector3.ZERO


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
	return true
	
	
func can_enter() -> bool:
	return host.is_on_floor()
	
	
func execute() -> void:
	dir = Vector3.ZERO
	if !host.can_act:
		return
		
	dir = host.get_wasd_cam()
	if host.in_combat:
		animation = get_strafe_dir()
		host.add_force(dir * speed / 3)
		host.lock_on()
	else:
		animation = "Walk"
		host.add_force(dir * speed)
		host.body_face(dir)
	pass
	
	
func get_strafe_dir():
	match dir.abs().max_axis():
		Vector3.AXIS_X:
			if dir.x > 0:
				return "Strafe_Right"
			elif dir.x < 0:
				return "Strafe_Left"
		Vector3.AXIS_Y:
			if dir.z > 0:
				return "Strafe_Forward"
			elif dir.z < 0:
				return "Strafe_Backwards"
	return "Strafe_Forward"
