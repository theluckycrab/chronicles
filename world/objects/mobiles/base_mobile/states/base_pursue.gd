extends ActionState

onready var tpos
var speed = 3

func _init() -> void:
	index = "Pursue"
	animation = "Strafe_Forward"
	priority = 1
	host = null
	
	
func enter() -> void:
	tpos = host.lock_target.global_transform.origin
	pass
	
	
func exit() -> void:
	pass
	
	
func can_exit() -> bool:
	return host.global_transform.origin.distance_to(tpos) < 4 or host.lock_target == null
	
	
func can_enter() -> bool:
	return true
	
	
func execute() -> void:
	tpos = host.lock_target.global_transform.origin
	var dir = host.global_transform.origin.direction_to(tpos)
	host.add_force(dir * speed)
	host.armature.face(dir)
	pass
