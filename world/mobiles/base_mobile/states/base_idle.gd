extends ActionState

func _init() -> void:
	index = "Idle"
	animation = "Idle"
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
	pass
