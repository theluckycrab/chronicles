extends MoveState


func _init() -> void:
	index = "Fall"
	animation = "Fall"
	priority = -1
	host = null


func enter() -> void:
	pass
	
	
func exit() -> void:
	pass
	
	
func can_exit() -> bool:
	return host.is_on_floor()
	
	
func can_enter() -> bool:
	return !host.is_on_floor()
	
	
func execute() -> void:
	pass
