extends PlayerMoveState


func _init() -> void:
	index = "Run"
	animation = "Run"
	priority = 0
	host = null


func controls() -> void:
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
	host.velocity.controlled *= 2
	pass

