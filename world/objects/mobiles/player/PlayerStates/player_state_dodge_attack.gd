extends PlayerActionState


func _init() -> void:
	index = "Dash Attack"
	animation = "Dash_Attack"
	priority = 3
	host = null


func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
	
func can_exit() -> bool:
	return host.get_animation() != animation
	
	
func can_enter() -> bool:
	return true
	
	
func execute() -> void:
	var dir = Vector3.BACK.rotated(Vector3.UP, host.armature.rotation.y) * 5
	host.add_force(dir)
	host.body_face(dir)
	host.lock_on()
	
