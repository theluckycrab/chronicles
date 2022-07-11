extends PlayerActionState


func _init() -> void:
	index = "Sheathe"
	animation = "Sheathe"
	priority = 1
	host = null
	
	
func enter() -> void:
	host.lock_target = null
	host.at_war = false
	yield(get_tree().create_timer(0.1), "timeout")
	pass
	
	
func exit() -> void:
	host.npc("hide_weapon", {})
	pass
	
	
func can_exit() -> bool:
	return host.get_animation() == ""
	
	
func can_enter() -> bool:
	return true
	
	
func execute() -> void:
	pass
