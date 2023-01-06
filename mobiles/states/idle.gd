extends State

func _init():
	priority = 0
	index = "Idle"

func can_enter():
	return host.get_wasd() == Vector3.ZERO
	
func can_exit():
	return host.get_wasd() != Vector3.ZERO

func enter():
	pass
	
func exit():
	pass
	
func execute():
	if host.has_lock_target():
		host.play("Fist_Idle")
	else:
		host.play("Idle")
	pass
