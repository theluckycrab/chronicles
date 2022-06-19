extends ActionState

var dir = "Forward"

func _init() -> void:
	index = "Defend"
	animation = "Guard_Forward"
	priority = 1
	host = null

	
func enter() -> void:
	host.npc("parry", {direction="Forward"})
	pass
	
	
func exit() -> void:
	host.npc("guard_reset", {})
	pass
	
	
func can_exit() -> bool:
	return host.get_animation() != animation
	
	
func can_enter() -> bool:
	return true
	
	
func execute() -> void:
	pass

