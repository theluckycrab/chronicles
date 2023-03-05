extends State

func _init() -> void:
	priority = 2
	index = "Attack"

func can_enter() -> bool:
	return host.is_on_floor()
	
func can_exit() -> bool:
	return ! host.armature.is_using_root_motion()

func enter() -> void:
	host.play("Strong", true)
		
func execute() -> void:
	pass
	
func exit() -> void:
	pass
	

