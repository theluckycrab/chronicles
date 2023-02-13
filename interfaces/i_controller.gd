extends BaseInterface
class_name IController

func _init(h).(h, "controller"):
	pass

func get_wasd() -> Vector3:
	var wasd = Vector3.ZERO
	wasd.x = Input.get_action_strength("a") - Input.get_action_strength("d")
	wasd.z = Input.get_action_strength("w") - Input.get_action_strength("s")
	return wasd
	
func get_wasd_cam() -> Vector3:
	return get_wasd().normalized().rotated(Vector3.UP, get_viewport().get_camera().rotation.y)
