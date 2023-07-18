extends State

func _init():
	priority = 5
	index = "Stagger"

func can_enter() -> bool:
	return true
	
func can_exit() -> bool:
	return ! host.armature.is_using_root_motion()

func enter() -> void:
	host.play("Stagger", true)
	pass
	
func exit() -> void:
	pass
	
func execute() -> void:
	pass
