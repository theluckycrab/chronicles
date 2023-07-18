extends State

var done = false

func _init():
	priority = 5
	index = "DownedUp"

func can_enter() -> bool:
	return host.is_on_floor()
	
func can_exit() -> bool:
	return ! host.armature.is_using_root_motion()

func enter() -> void:
	host.play("Downed_Up", true)
	pass
	
func exit() -> void:
	pass
	
func execute() -> void:
	pass
