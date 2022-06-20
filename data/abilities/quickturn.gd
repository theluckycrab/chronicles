extends Ability

func _init() -> void:
	index = "Quickturn"
	animation = "Fall"
	priority = 2
	host = null


func enter() -> void:
	host.state_machine.get_state("walk").dir = host.get_wasd_cam()
	host.body_face(host.get_wasd_cam())
	keyframe_connect()
	#host.hide_weapon()
	pass


func exit() -> void:
	keyframe_disconnect()
	#combat_check()
	completed()
	pass


func can_enter() -> bool:
	return host.is_on_floor()


func can_exit() -> bool:
	return host.get_animation() != animation


func execute() -> void:
	pass
