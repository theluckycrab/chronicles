extends PlayerMoveState


func _init() -> void:
	index = "Idle"
	animation = "Idle"
	priority = -1
	host = null

func _controls() -> void:
	pass
	
	
func enter() -> void:
	if host.in_combat:
		animation = "Combat_Idle"
	else:
		animation = "Idle"
	pass
	
	
func exit() -> void:
	pass
	
	
func can_exit() -> bool:
	return true
	
	
func can_enter() -> bool:
	return host.is_on_floor() and host.get_wasd() == Vector3.ZERO
	
	
func execute() -> void:
	host.lock_on()
	if Input.is_action_pressed("guard"):
		host.set_state("guard")
	pass
