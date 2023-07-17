extends State

func _init():
	priority = 1
	index = "Draw"

func can_enter() -> bool:
	return host.is_on_floor()
	
func can_exit() -> bool:
	return ! host.armature.is_using_root_motion()

func enter() -> void:
	if host.weapon_drawn:
		host.play("Sheathe", true)
	else:
		host.play("Draw", true)
	host.weapon_drawn = !host.weapon_drawn
	host.toggle_lock_on()
	pass
	
func exit() -> void:
	pass
	
func execute() -> void:
	pass
