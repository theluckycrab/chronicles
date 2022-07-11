extends ActionState


func _init() -> void:
	index = "Warcry"
	animation = "Taunt"
	priority = 1
	host = null
	
	
func enter() -> void:
	var slots = ["Head", "Boots", "Mainhand", "Offhand"]
	var slot = randi() % slots.size()
	host.activate_item_slot(slots[slot])
	pass
	
	
func exit() -> void:
	pass
	
	
func can_exit() -> bool:
	return host.get_animation() != animation
	
	
func can_enter() -> bool:
	return true
	
	
func execute() -> void:
	pass
