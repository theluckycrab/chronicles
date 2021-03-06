extends ActionState

onready var tpos
var speed = 3

func _init() -> void:
	index = "Pursue"
	animation = "Strafe_Forward"
	priority = 1
	host = null
	
	
func enter() -> void:
	if is_instance_valid(host.lock_target):
		tpos = host.lock_target.global_transform.origin
	else:
		tpos = Vector3.ZERO
	pass
	
	
func exit() -> void:
	pass
	
	
func can_exit() -> bool:
	return host.global_transform.origin.distance_to(tpos) < 2.25 or host.lock_target == null
	
	
func can_enter() -> bool:
	return true
	
	
func execute() -> void:
	if is_instance_valid(host.lock_target):
		tpos = host.lock_target.global_transform.origin
		var dir = host.global_transform.origin.direction_to(tpos)
		host.add_force(dir * speed)
		host.armature.face(dir)
	pass
