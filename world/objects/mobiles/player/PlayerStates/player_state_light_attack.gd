extends PlayerActionState


func _init() -> void:
	index = "Light Attack"
	animation = "Test_LAttack1"
	priority = 1
	host = null


func controls() -> String:
	return "Light Attack"
	
	
func enter() -> void:
	pass
	
	
func exit() -> void:
	pass
	
	
func can_exit() -> bool:
	#print(host.anim.current_animation)
	return host.get_animation() != animation
	
	
func can_enter() -> bool:
	return true
	
	
func execute() -> void:
	pass
