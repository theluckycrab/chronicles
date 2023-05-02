extends State

func _init():
	priority = 0
	index = "Idle"

func can_enter() -> bool:
	return ! is_instance_valid(host.lock_target)
	
func can_exit() -> bool:
	return true

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func execute() -> void:
	host.set_velocity(Vector3(1,0,0))
