extends State

func _init():
	priority = 5
	index = "Break"

func can_enter() -> bool:
	return true
	
func can_exit() -> bool:
	return ! host.armature.is_using_root_motion()

func enter() -> void:
	host.play("Break", true)
	pass
	
func exit() -> void:
	pass
	
func execute() -> void:
	host.add_force(Vector3.DOWN * 3)
	pass
