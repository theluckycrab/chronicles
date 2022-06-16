extends PlayerActionState


func _init() -> void:
	index = "Sheathe"
	animation = "Sheathe"
	priority = 1
	host = null
	
	
func enter() -> void:
	host.lock_target = null
	pass
	
	
func exit() -> void:
	host.at_war = false
	host.npc("hide_weapon", {})
	pass
	
	
func can_exit() -> bool:
	return host.get_animation() == ""
	
	
func can_enter() -> bool:
	return true
	
	
func execute() -> void:
	pass
