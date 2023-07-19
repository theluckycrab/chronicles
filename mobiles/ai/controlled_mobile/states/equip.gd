extends State

func _init():
	priority = 3
	index = "Block"

func can_enter() -> bool:
	return true
	
func can_exit() -> bool:
	return ! host.armature.is_using_root_motion()

func enter() -> void:
	host.play("Block", true)
	pass
	
func exit() -> void:
	pass
	
func execute() -> void:
	pass
