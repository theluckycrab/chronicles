extends Ability

func _init() -> void:
	index = "Phase Out"
	animation = "Item"
	priority = 2
	host = null


func enter() -> void:
	keyframe_connect()
	hide_weapon()
	pass


func exit() -> void:
	keyframe_disconnect()
	#combat_check()
	completed()
	Events.emit_signal("scene_change_request", "lobi_town")
	pass


func can_enter() -> bool:
	return host.is_on_floor()


func can_exit() -> bool:
	return host.get_animation() != animation


func execute() -> void:
	pass
	
func on_keyframe():
	pass

