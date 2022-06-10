extends ActionState


func _init() -> void:
	index = "Patrol"
	animation = "Walk"
	priority = 1
	host = null
	
	
func enter() -> void:
	pass
	
	
func exit() -> void:
	pass
	
	
func can_exit() -> bool:
	return host.lock_target
	
	
func can_enter() -> bool:
	return true
	

var mypos = Vector3.ZERO
var tpos = Vector3.ZERO
	
func execute() -> void:
	if host.lock_target != null:
		return
		
	host.play("Walk")
		
	var dist = host.distance_to(tpos)
	
	if tpos == Vector3.ZERO or dist < 1:
		choose_next_patrol_point()
	else:
		pursue_next_patrol_point()
	
	host.acquire_lock_target()


func choose_next_patrol_point():
	var rand3 = Vector3(randi() % 10, 0, randi() % 10)
	var invert = randi() % 2
	
	if invert == 0:
		rand3 *= -1
	
	tpos = mypos + rand3


func pursue_next_patrol_point():
	host.add_force(host.direction_to(tpos) * Vector3(1,0,1))
	host.armature.face(host.direction_to(tpos))
