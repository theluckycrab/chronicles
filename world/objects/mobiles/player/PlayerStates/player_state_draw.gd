extends PlayerActionState


func _init() -> void:
	index = "Draw"
	animation = "Draw"
	priority = 1
	host = null


func controls() -> String:
	return "Draw"
	
	
func enter() -> void:
	host.lock_target = null
	pass
	
	
func exit() -> void:
	host.at_war = !host.at_war
	if host.at_war:
		host.npc("show_weapon", {})
	else:
		host.npc("hide_weapon", {})
	pass
	
	
func can_exit() -> bool:
	return host.get_animation() == ""
	
	
func can_enter() -> bool:
	return true
	
	
func execute() -> void:
	pass
