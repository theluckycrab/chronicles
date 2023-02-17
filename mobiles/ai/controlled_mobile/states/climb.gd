extends State

func _init() -> void:
	priority = 2
	index = "Climb"

func can_enter() -> bool:
	return true
	
func can_exit() -> bool:
	return ! host.armature.is_using_root_motion()

func enter() -> void:
	host.play("UpLedge", true)
	
func exit() -> void:
	pass
	
func execute() -> void:
	host.add_force(Vector3.UP)
	pass
