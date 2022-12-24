extends State

func _init():
	priority = 0

func can_enter():
	return true
	
func can_exit():
	return true

func enter():
	pass
	
func exit():
	pass
	
func execute(host):
	var wasd = host.get_wasd_cam()
	if wasd != Vector3.ZERO:
		host.move_and_slide(wasd * host.move_stats.base_speed)
		host.armature.face_dir(host.get_wasd_cam(), host.stored_delta)
	pass

