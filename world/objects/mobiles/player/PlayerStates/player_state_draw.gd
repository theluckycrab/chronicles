extends PlayerActionState


func _init() -> void:
	index = "Draw"
	animation = "Draw"
	priority = 1
	host = null


func controls() -> String:
	return "Draw"
	
	
func enter() -> void:
	pass
	
	
func exit() -> void:
	if host.flags.at_war:
		host.set_peace()
	elif !host.flags.at_war:
		host.set_war()
	pass
	
	
func can_exit() -> bool:
	print(host.anim.current_animation)
	return host.anim.current_animation != animation
	
	
func can_enter() -> bool:
	return true
	
	
func execute() -> void:
	pass
