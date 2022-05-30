extends PlayerMoveState


func _init() -> void:
	index = "Idle"
	animation = "Idle"
	priority = -1
	host = null

func _controls() -> void:
	pass
	
	
func enter() -> void:
	pass
	
	
func exit() -> void:
	pass
	
	
func can_exit() -> bool:
	return true
	
	
func can_enter() -> bool:
	return host.is_on_floor() and host.velocity.controlled == Vector3.ZERO
	
	
func execute() -> void:
	if host.flags.at_war:
		host.anim.play("Combat_Idle")
	else:
		host.anim.play("Idle")
	pass
