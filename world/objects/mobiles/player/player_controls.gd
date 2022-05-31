extends Node


func get_wasd() -> Vector3:
	var x = Input.get_action_strength("d") - Input.get_action_strength("a")
	var y = Input.get_action_strength("s") - Input.get_action_strength("w")
	return Vector3(x, 0, y)
	
	
func get_wasd_cam() -> Vector3:
	var cam = get_viewport().get_camera()
	var wasd = get_wasd()
	var cam_rot = 0
	
	if cam == null:
		return Vector3.ZERO
		
	elif cam.has_method("get_h_rotation"):
		cam_rot = cam.get_h_rotation()
	else:
		cam_rot = cam.rotation.y
	
	wasd = wasd.rotated(Vector3.UP, cam_rot)
	return wasd
	
