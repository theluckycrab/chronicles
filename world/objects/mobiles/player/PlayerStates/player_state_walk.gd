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
	return true
	
	
func can_enter() -> bool:
	return host.is_on_floor() and !host.velocity.controlled == Vector3.ZERO
	
	
func execute() -> void:
#	sprinting = Input.is_action_pressed("sprint")
#	if sprinting:
#		host.velocity.controlled *= 2
#		host.Animate("Idle")
	pass
	
	
