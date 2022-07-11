extends PlayerActionState


func _init() -> void:
	index = "Interact"
	animation = "Interact"
	priority = 3
	host = null
	
	
func enter() -> void:
	pass
	
	
func exit() -> void:
	pass
	
	
func can_exit() -> bool:
	return host.get_animation() != animation
	
	
func can_enter() -> bool:
	return true
	
	
func execute() -> void:
	pass

